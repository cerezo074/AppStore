//
//  AppDetailPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol AppDetailViewProtocol {
    func downloadingAppImage(image: UIImage?)
    func downloadedAppImage()
    func appImageNotDownloaded(image: UIImage?)
}

protocol AppIconDelegate {
    func appWasUpdated(app: App)
}

struct AppDetailPresenter {
    
    private let imageDownloader: ImageDownloaderProtocol
    private var appDetailView: AppDetailViewProtocol
    private(set) var app: App
    fileprivate let placeHolder = UIImage(named: "placeholder")
    fileprivate let notFoundedImage =  UIImage(named: "image_not_founded")
    var iconDelegate: AppIconDelegate?
    
    var imageDownloaded: UIImage? {
        didSet {
            guard let imageAdded = imageDownloaded else {
                appDetailView.appImageNotDownloaded(image: notFoundedImage)
                return
            }
            app.image = imageAdded
            iconDelegate?.appWasUpdated(app: app)
            appDetailView.downloadedAppImage()
        }
    }
    
    init(app: App,
         imageDownloader: ImageDownloaderProtocol,
         appDetailView: AppDetailViewProtocol) {
        self.app = app
        self.imageDownloader = imageDownloader
        self.appDetailView = appDetailView
    }
    
    mutating func shouldDownloadImage() {
        guard let iconURL = app.iconURL, app.image == nil else {
            return
        }
        
        if let icon = imageDownloader.image(withIdentifier: iconURL.absoluteString) {
            imageDownloaded = icon
            self.appDetailView.downloadedAppImage()
            return
        }
        
        appDetailView.downloadingAppImage(image: placeHolder)
        let request = URLRequest(url: iconURL)
        weak var weakImage = imageDownloaded
        
        imageDownloader.downloadImage(urlRequest: request) { (iconImage, error) in
            guard let iconDownloaded = iconImage else {
                weakImage = nil
                return
            }
            weakImage = iconDownloaded
        }
    }
    
}
