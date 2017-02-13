//
//  AlamofireImageDownloader.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import AlamofireImage

struct AlamofireImageDownloader: ImageDownloaderProtocol {
    
    private let downloader: ImageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                              downloadPrioritization: .fifo,
                                                              maximumActiveDownloads: 10,
                                                              imageCache: AutoPurgingImageCache())
    
    func downloadImage(urlRequest: URLRequest, completionBlock: @escaping ImageDownloaderProtocol.Result) {
        downloader.download(urlRequest) {
            response in
            completionBlock(response.result.value, response.result.error)
        }
    }
    
    func image(withIdentifier identifier: String) -> Image? {
        return downloader.imageCache?.image(withIdentifier: identifier)
    }
    
}
