//
//  DiskRepository.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

protocol DiskRepositoryProtocol {
    typealias PerformTaskBlock = (_ completed: Bool, _ error: Error?) -> Void
    typealias PerformTaskWithResultBlock = (_ result: Any?, _ error: Error?) -> Void
    typealias PerformTaskWithMultipleResultBlock = (_ result: [Any]?, _ error: Error?) -> Void
    func saveApps(apps: [App], completion: @escaping PerformTaskBlock)
    func loadApps() -> [App]?
    func getCategories(completion: @escaping PerformTaskWithMultipleResultBlock)
}
