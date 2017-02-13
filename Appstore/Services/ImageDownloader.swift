//
//  ImageDownloader.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloaderProtocol {
    typealias Result = (UIImage?, Error?) -> Void
    func image(withIdentifier identifier: String) -> UIImage?
    func downloadImage(urlRequest: URLRequest ,completionBlock: @escaping Result)
}
