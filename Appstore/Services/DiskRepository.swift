//
//  DiskRepository.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

enum DataSaveResult {
    case success
    case error(message: String)
}

protocol DiskRepositoryProtocol {
    func saveApps(app: [App], completion: (DataSaveResult) -> Void)
    func loadApps() -> [App]?
}
