//
//  DatabaseManager.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public struct RealmChangeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]

    /// the indexes in the collection that were inserted
    public let inserted: [Int]

    /// the indexes in the collection that were modified
    public let updated: [Int]
}

final class DataProvider {
    static let shared = DataProvider()

    fileprivate var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private init() { }

    //  MARK: - fetch objects
    
    func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> [T] {
        let results: Results<T> = realm.objects(type).filter(predicate)
        return Array(results)
    }

    func objects<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil, sortBy propertiesSort: [String: Bool]? = nil) -> Results<T> {
        var results: Results<T>
        if let pre = predicate {
            results = realm.objects(type).filter(pre)
        } else {
            results = realm.objects(type)
        }

        if let propertiesSort = propertiesSort {
            for property in propertiesSort {
                results = results.sorted(byKeyPath: property.0, ascending: property.1)
            }
        }
        return results
    }

    // MARK: Update
    func add<T: Object>(_ object: T) {
        do {
            realm.beginWrite()
            realm.add(object, update: true)
            try realm.commitWrite()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func write() -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.realm.write {
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DataProvider {
    func add<T: RealmSwift.Object, S: Sequence>(_ objects: S) where S.Iterator.Element == T {
        do {
            realm.beginWrite()
            realm.add(objects, update: true)
            try realm.commitWrite()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func delete<T: RealmSwift.Object, S: Sequence>(_ objects: S) where S.Iterator.Element == T {
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
extension DataProvider {
    // MARK :- Observer collection change

    func collection<T>(from data: Results<T>) -> Observable<[T]> {
        return Observable<[T]>.create({ observer -> Disposable in
            let token = data.observe { (collectionChange) in
                switch collectionChange {
                case .update(let results, _, _, _):
                    var temps: [T] = []
                    temps.append(contentsOf: results)
                    observer.onNext(temps)
                case .initial(_): break
                case .error(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                token.invalidate()
            }
        })
    }

    func changeset<T>(from data: Results<T>) -> Observable<([T], RealmChangeset)> {
        return Observable<([T], RealmChangeset)>.create({ observer -> Disposable in
            let token = data.observe({ (collectionChange) in
                switch collectionChange {
                case .update(let results, let deletions, let insertions, let modifications):
                    let changeset = RealmChangeset(deleted: deletions, inserted: insertions, updated: modifications)
                    var temps: [T] = []
                    temps.append(contentsOf: results)
                    observer.onNext((temps, changeset))
                case .initial(_): break
                case .error(let error):
                    observer.onError(error)
                }
            })

            return Disposables.create {
                token.invalidate()
            }
        })
    }

    // MARK :- Observer object change

    func propertyChanges<T>(from object: T) -> Observable<PropertyChange> where T: Object {
        return Observable<PropertyChange>.create { observer in
            let token = object.observe { change in
                switch change {
                case .change(let changes):
                    for change in changes {
                        observer.onNext(change)
                    }
                case .deleted: break
                case .error(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                token.invalidate()
            }
        }
    }
}
