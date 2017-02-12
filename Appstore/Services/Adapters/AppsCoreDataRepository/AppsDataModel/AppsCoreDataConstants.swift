//
//  AppsCoreDataConstants.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

struct AppsManagedObjectModel {
    static let appsDataModel = "AppsCoreDataModel"
}

struct AppsPersistentStore {
    private static let name = "AppsModel"
    private static let fileExtension = ".sqlite"
    static let appsPersistenceStore = AppsPersistentStore.name + AppsPersistentStore.fileExtension
}
