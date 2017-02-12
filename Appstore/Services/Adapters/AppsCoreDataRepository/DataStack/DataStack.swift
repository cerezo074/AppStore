//
//  DataStack.swift
//  Persistence_CoreData
//
//  Created by Eli Pacheco Hoyos on 12/16/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ContextHasChangedProtocol {
    func storeShouldChange(notification: Notification)
}

extension ContextHasChangedProtocol {
    
    func registerForDidSaveNotification(obj: Any) {
        let selector = #selector(ContextHasChangedProtocol.storeShouldChange(notification:))
        NotificationCenter.default.addObserver(obj,
                                               selector: selector,
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    func unregisterForDidSaveNotification(obj: Any) {
        NotificationCenter.default.removeObserver(obj,
                                                  name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                  object: nil)
    }
    
}

let PersistentStoreWasLoadedNotification = NSNotification.Name("PersistenStoreWasLoadedNotification")

class DataStack: NSObject {
    
    private(set) var persistenceStore: String
    private(set) var dataModel: String
    
    fileprivate var persistenceContext: NSManagedObjectContext
    fileprivate var mainContext: NSManagedObjectContext
    
    fileprivate var managedObjectModel: NSManagedObjectModel?
    fileprivate var persistenceStoreCoordinator: NSPersistentStoreCoordinator?
    fileprivate var persistenceStoreURL: URL?
    
    init?(dataModel: String, persistenceStore: String) {
        
        self.dataModel = dataModel
        self.persistenceStore = persistenceStore
        
        guard let managedObjectModelPath = Bundle.main.url(forResource: dataModel,
                                                           withExtension: "momd") else {
                                                            assertionFailure("Error loading scheme path.")
                                                            return nil
        }
        
        guard let moModel = NSManagedObjectModel(contentsOf: managedObjectModelPath) else {
            assertionFailure("Error loading scheme")
            return nil
        }
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: moModel)
        
        persistenceContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistenceContext.persistentStoreCoordinator = storeCoordinator
        persistenceContext.undoManager = nil
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = persistenceContext
        mainContext.undoManager = nil
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex - 1]
        let storeURL = docURL.appendingPathComponent(persistenceStore)
        print("DataStore path: \(storeURL)")
        
        DispatchQueue.global().async {
            //Use this option for migrations
//            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
//                           NSInferMappingModelAutomaticallyOption: true]
            do {
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                  configurationName: nil,
                                                                  at: storeURL,
                                                                  options: nil)
                NotificationCenter.default.post(name: PersistentStoreWasLoadedNotification,
                                                object: nil)
                print("Persisten Store loaded on coordinator")
            } catch {
                assertionFailure("Error adding persistence store \(error)")
            }
        }
        
        persistenceStoreURL = storeURL
        managedObjectModel = moModel
        persistenceStoreCoordinator = storeCoordinator
        
        super.init()
        registerForDidSaveNotification(obj: self)
    }
    
    deinit {
        unregisterForDidSaveNotification(obj: self)
    }
    
}

extension DataStack: CoreDataSourceStackProtocol {

    func fastSaveContext() -> NSManagedObjectContext {
        return persistenceContext
    }
    
    func saveContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext
        privateContext.undoManager = nil
        
        return privateContext
    }
    
    func readContext() -> NSManagedObjectContext {
        return mainContext
    }

}

extension DataStack: ContextHasChangedProtocol {

    func storeShouldChange(notification: Notification) {
        guard let moc = notification.object as? NSManagedObjectContext,
        let parent = moc.parent else {
            return
        }
        
        if parent == mainContext {
            saveChangesOnMainMOC()
        }
        
        if parent == persistenceContext {
            saveChangesOnPersistentMOC()
        }
    }
    
    func saveChangesOnMainMOC() {
        
        if !mainContext.hasChanges {
            print("You doesn't have changes on main context!")
            return
        }
        
        unowned let unownedMainMOC = mainContext
        mainContext.perform {
            do {
                try unownedMainMOC.save()
                print("Changes was saved on main context!")
            } catch {
                print("Error trying to saving changes on main context: \(error)")
            }
        }
    }
    
    func saveChangesOnPersistentMOC() {
        
        if !persistenceContext.hasChanges {
            print("You doesn't have changes on persistent context!")
            return
        }
        
        unowned let unownedPersistentMOC = persistenceContext
        persistenceContext.perform {
            do {
                try unownedPersistentMOC.save()
                print("Changes was saved on persisten context!")
            } catch {
                print("Error trying to saving changes on persitence context: \(error)")
            }
        }
    }
    
}
