//
//  AppsCoreDataDAO.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import CoreData

struct AppsCoreDataDAO: DiskRepositoryProtocol {
    
    fileprivate let appEntityName = "AppEntity"
    fileprivate let dataSource: CoreDataSourceStackProtocol
    
    init(dataSource: CoreDataSourceStackProtocol) {
        self.dataSource = dataSource
    }
    
    func loadApps() -> [App]? {
        let readContext = dataSource.readContext()
        let appsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: appEntityName)
        guard let appsEntities = readSync(context: readContext, fetchRequest: appsFetchRequest) as? [AppEntity] else {
            return nil
        }
        
        let apps = appsEntities.map { (entity) -> App in
            return self.createApp(from: entity)
        }
        
        return apps
    }
    
    func saveApps(apps: [App], completion: @escaping DiskRepositoryProtocol.PerformTaskBlock) {
        let saveContext = dataSource.fastSaveContext()
        deleteAllApps(context: saveContext) { (result, error) in
            if result {
                for app in apps {
                    self.createAppEntity(app: app, context: saveContext)
                }
                
                do {
                    try saveContext.save()
                    self.callOnMainThreadSimpleBlock(completionBlock: completion,
                                                result: true,
                                                error: error)
                } catch {
                    self.callOnMainThreadSimpleBlock(completionBlock: completion,
                                                result: true,
                                                error: error)
                }
            } else {
                self.callOnMainThreadSimpleBlock(completionBlock: completion,
                                        result: true,
                                        error: error)
            }
        }
    }
    
}

extension AppsCoreDataDAO: BasicDAO {
    
    fileprivate func createAppEntity(app: App,
                                     context: NSManagedObjectContext) {
        guard let newEntity = NSEntityDescription.insertNewObject(forEntityName: appEntityName, into: context) as? AppEntity else {
            print("App \(app.appstoreID) couldn't be insert in context")
            return
        }
        
        newEntity.appstoreID = app.appstoreID
        newEntity.artist = app.artist
        newEntity.category = app.category
        newEntity.detailName = app.detailName
        newEntity.iconURL = app.iconURL?.absoluteString
        newEntity.releaseDate = app.releaseDate
        newEntity.rights = app.rights
        newEntity.shortName = app.shortName
        newEntity.summary = app.summary
        newEntity.price = app.price
        
        do {
            try newEntity.validateForInsert()
        } catch {
            print("Error, app can't be valid for insert \(error.localizedDescription)")
        }
    }
    
    fileprivate func createApp(from entity: AppEntity) -> App {
        
        var app = App()
        
        if let appstoreID = entity.appstoreID {
            app.appstoreID = appstoreID
        }
        
        if let shortName = entity.shortName {
            app.shortName = shortName
        }
        
        if let detailName = entity.detailName {
            app.detailName = detailName
        }
        
        if let artist = entity.artist {
            app.artist = artist
        }
        
        if let category = entity.category {
            app.category = category
        }
        
        if let releaseDate = entity.releaseDate {
            app.releaseDate = releaseDate
        }
        
        if let summary = entity.summary {
            app.summary = summary
        }
        
        if let rights = entity.rights {
            app.rights = rights
        }
        
        if let price = entity.price {
            app.price = price
        }
        
        if let iconURLString = entity.iconURL,
            let iconURL = URL(string: iconURLString) {
            app.iconURL = iconURL
        }
        
        return app
    }
    
    fileprivate func deleteAllApps(context: NSManagedObjectContext,
                                   completion: @escaping DiskRepositoryProtocol.PerformTaskBlock)  {
        let validationRequest = NSFetchRequest<NSFetchRequestResult>(entityName: appEntityName)
        delete(context: context, validationRequest: validationRequest, completionBlock: completion)
    }
    
    fileprivate func readSync(context: NSManagedObjectContext,
                  fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]? {
        let contactsFetched = try? context.fetch(fetchRequest)
        return contactsFetched as? [NSManagedObject]
    }
    
    fileprivate func delete(context: NSManagedObjectContext,
                validationRequest: NSFetchRequest<NSFetchRequestResult>,
                completionBlock: @escaping DiskRepositoryProtocol.PerformTaskBlock) {
        
        unowned let unownedContext = context
        context.performAndWait {
            do {
                let objectsArray = self.readSync(context: unownedContext, fetchRequest: validationRequest)
                if let objects = objectsArray, objects.count >= 1 {
                    for object in objects {
                        unownedContext.delete(object)
                        try unownedContext.save()
                    }
                }
                completionBlock(true, nil)
            } catch {
                completionBlock(false, error)
            }
        }
        
    }
    
}
