//
//  RealmManager.swift
//  RealmManager
//
//  Created by Metilli on 7.08.2022.
//

import Foundation
import RealmSwift

public struct RealmManager {
    
    private static func realmDeleteIfNeededConfig() -> Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        return config
    }
    
    public static func setup(configuration: Realm.Configuration? = nil) {
        do {
            if let safeConfig = configuration  {
                _ = try Realm(configuration: safeConfig)
            } else {
                _ = try Realm(configuration: RealmManager.realmDeleteIfNeededConfig())
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public static var realmFileURL: URL? {
        return try! Realm().configuration.fileURL
    }
    
    /// Add the given objects to the database.
    /// 
    /// - Parameter object: The type of object to add.
    /// - Parameter update: The realm update policy
    public static func add<T: Object>(_ data: [T], update: Realm.UpdatePolicy = .error) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(data, update: update)
        }
    }
    
    /// Add the given object to the database.
    ///
    /// - Parameter object: The type of object to add.
    /// - Parameter update: The realm update policy
    public static func add<T: Object>(_ data: T, update: Realm.UpdatePolicy = .error) {
        add([data], update: update)
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Parameter predicate: Predicate for filtering.
    /// - Returns: The results in the database for the given object type.
    public static func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T> {
        let realm = try! Realm()
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Parameter key: Primary key of the object.
    /// - Returns: The result in the database for the given object type with spesific primary key..
    public static func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        let realm = try! Realm()
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    /// Delete all entities by given object type and add given object to database
    ///
    /// - Parameter object: The object to add the database.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public static func replaceObject<T: Object>(_ object: T, cascadeDelete: Bool = true) {
        let realm = try! Realm()
        let deleteObjects = realm.objects(T.self)
        try! realm.write {
            realm.delete(deleteObjects, cascading: true)
            realm.add(object)
        }
    }
    
    /// Deletes the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public static func delete<T: Object>(_ object: [T], cascading: Bool = true) {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(object, cascading: cascading)
        }
    }
    
    /// Delete the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public static func delete<T: Object>(_ object: T, cascading: Bool = true) {
        delete([object], cascading: cascading)
    }
    
    /// Clear all data from the database.
    public static func deleteAll() {
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
    }
    
}
