//
//  RealmManager.swift
//  RealmManager
//
//  Created by Metilli on 7.08.2022.
//

import Foundation
import RealmSwift

public struct RealmManager {
    
    public typealias completion = (Result<Any?,Error>) -> ()
    
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
        let realm = try! Realm()
        return realm.configuration.fileURL
    }
    
    /// Add the given objects to the database.
    public static func add<T: Object>(_ data: [T], completionHandler: @escaping completion) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(data)
            }
            completionHandler(.success(nil))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    /// Add the given object to the database.
    public static func add<T: Object>(_ data: T, completionHandler: @escaping completion) {
        add([data], completionHandler: completionHandler)
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
    public static func replaceObject<T: Object>(_ object: T, cascadeDelete: Bool = true, completionHandler: @escaping completion) {
        do {
            let realm = try Realm()
            let deleteObjects = realm.objects(T.self)
            try realm.write {
                realm.delete(deleteObjects, cascading: true)
                realm.add(object)
            }
            completionHandler(.success(nil))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    /// Deletes the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public static func delete<T: Object>(_ object: [T], cascading: Bool = true, completionHandler: @escaping completion) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.delete(object, cascading: cascading)
            }
            completionHandler(.success(nil))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    /// Delete the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public static func delete<T: Object>(_ object: T, cascading: Bool = true, completionHandler: @escaping completion) {
        delete([object], cascading: cascading, completionHandler: completionHandler)
    }
    
    /// Clear all data from the database.
    public static func deleteAll(completionHandler: @escaping completion) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
            completionHandler(.success(nil))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
}
