//
//  DatabaseManager.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    static let shared = DatabaseManager()

    var realm: Realm {
        var realm: Realm!
        do {
            realm = try Realm()
        } catch {
            let storePath = Realm.Configuration.defaultConfiguration.fileURL!.path
            do {
                try FileManager.default.removeItem(atPath: storePath)
                realm = try! Realm()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return realm
    }

    private init() { }

    func documentPath() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
}

extension DatabaseManager {
    //  MARK: - fetch object
    open func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil) -> T? {
        let results: Results<T> = predicate != nil ? realm.objects(type).filter(predicate!) : realm.objects(type)
        if results.count > 0 {
            return results.first
        }
        return nil
    }

    //  MARK: - fetch objects
    open func objects<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil, sortBy propertiesSort: [String: Bool]? = nil) -> Results<T> {
        var results = predicate != nil ? realm.objects(type).filter(predicate!) : realm.objects(type)
        if let propertiesSort = propertiesSort {
            for property in propertiesSort {
                results = results.sorted(byKeyPath: property.0, ascending: property.1)
            }
        }
        return results
    }

    //  MARK: - add object
    open func addObject<T: Object>(_ object: T) {
        do {
            realm.beginWrite()
            realm.add(object, update: true)
            try realm.commitWrite()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    //  MARK: - update object
    open func updateObject(_ block:() -> ()) {
        try! realm.write {
            block()
        }
    }

    //  MARK: - remove object
    open func deleteObject<T: Object>(_ object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }

    open func deleteObjects<T: RealmSwift.Object, S: Sequence>(_ objects: S) where S.Iterator.Element == T {
        try! realm.write {
            realm.delete(objects)
        }
    }
}


