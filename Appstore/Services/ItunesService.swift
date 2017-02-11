//
//  ItunesService.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

protocol ItunesServiceProtocol {
    func downloadApps() -> [AppDTO]?
}
