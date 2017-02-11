//
//  ItunesService.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

enum AppStoreResponse {
    case failure
    case notConnectedToInternet
    case success(apps: [App])
}

extension AppStoreResponse: Equatable {
    static func ==(left: AppStoreResponse, right: AppStoreResponse) -> Bool {
        switch (left, right) {
        case (.failure, failure):
            return true
        case (.notConnectedToInternet, .notConnectedToInternet):
            return true
        case (.success(let apps), .success(let apps2)):
            return apps == apps2
        default:
            return false
        }
    }
}

protocol ItunesServiceProtocol {
    func downloadApps(amount: Int, completion: @escaping (AppStoreResponse) -> Void)
}
