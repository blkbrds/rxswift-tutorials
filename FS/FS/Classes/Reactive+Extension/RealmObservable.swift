//
//  RealmObservable.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/8/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import RxSwift
import RealmSwift

final class RealmObservable {
    // MARK :- Observer collection change
    static func collection<T>(from data: Results<T>) -> Observable<[T]> {
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

    static func changeset<T>(from data: Results<T>) -> Observable<([T], RealmChangeset)> {
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
    static func propertyChanges<T>(from object: T) -> Observable<PropertyChange> where T: Object {
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


public struct RealmChangeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]

    /// the indexes in the collection that were inserted
    public let inserted: [Int]

    /// the indexes in the collection that were modified
    public let updated: [Int]
}
