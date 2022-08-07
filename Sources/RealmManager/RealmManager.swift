//
//  RealmManager.swift
//  RealmManager
//
//  Created by Metilli on 7.08.2022.
//

import Foundation
import RealmSwift

public class RealmManager {
    
    public typealias onError = (_ error: Error?) -> Void
    
    private var realm: Realm
    
    public static var configuration: Realm.Configuration?
    
    private static func realmDeleteIfNeededConfig() -> Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        return config
    }
    
    public static let shared = RealmManager()
    
    init() {
        do {
            if let safeConfig = RealmManager.configuration  {
                realm = try Realm.init(configuration: safeConfig)
            } else {
                realm = try Realm.init(configuration: RealmManager.realmDeleteIfNeededConfig())
            }
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Add the given objects to the database.
    public func add<T: Object>(_ data: [T], onError: @escaping onError) {
        do {
            try realm.write{
                realm.add(data)
            }
        } catch {
            onError(error)
        }
    }
    
    /// Add the given object to the database.
    public func add<T: Object>(_ data: T, onError: @escaping onError) {
        add([data], onError: onError)
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Parameter predicate: Predicate for filtering.
    /// - Returns: The results in the database for the given object type.
    public func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T> {
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Parameter key: Primary key of the object.
    /// - Returns: The result in the database for the given object type with spesific primary key..
    public func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    /// Retrieves the given object type from the database.
    ///
    /// - Parameter object: The type of object to retrieve.
    /// - Parameter predicate: Predicate for filtering.
    /// - Returns: The results in the database for the given object type.
    public func addAndDelete<T: Object>(itemToAdd: T, itemToDelete: T.Type, cascadeDelete: Bool = true, onError: @escaping (_ error: Error?)-> Void) {
        do {
            let deleteObject = realm.objects(itemToDelete)
            try realm.write {
                realm.delete(deleteObject, cascading: true)
                realm.add(itemToAdd)
            }
            onError(nil)
        } catch {
            onError(error)
        }
    }
    
    /// Deletes the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public func delete<T: Object>(_ object: [T], cascading: Bool = true, onError: @escaping onError) {
        do {
            try realm.write{
                realm.delete(object, cascading: cascading)
            }
        } catch {
            onError(error)
        }
    }
    
    /// Delete the given objects type from the database.
    ///
    /// - Parameter object: The object will be deleted.
    /// - Parameter cascading: A Boolean value that determines whether the object's nested objects will be deleted.
    public func delete<T: Object>(_ object: T, cascading: Bool = true, onError: @escaping onError) {
        delete([object], cascading: cascading, onError: onError)
    }
    
    /// Clear all data from the database.
    public func deleteAll(onError: @escaping onError) {
        do {
            try realm.write{
                realm.deleteAll()
            }
        } catch {
            onError(error)
        }
    }
    
}
