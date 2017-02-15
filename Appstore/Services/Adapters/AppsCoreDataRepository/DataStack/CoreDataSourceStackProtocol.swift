//
//  CoreDataSourceStackProtocol.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataSourceStackProtocol {
    func readContext() -> NSManagedObjectContext
    func saveContext() -> NSManagedObjectContext
    
    //This context is attached with the Persistence Store directly
    func fastSaveContext() -> NSManagedObjectContext
}
