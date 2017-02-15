//
//  AppDetailPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol AppDetailViewProtocol: class {
    func downloadingAppImage(image: UIImage?)
    func downloadedAppImage()
    func appImageNotDownloaded(image: UIImage?)
}

protocol AppIconDelegate {
    func appWasUpdated(app: App)
}

struct AppDetailPresenter {
    
    private unowned let appDetailView: AppDetailViewProtocol
    private let imageDownloader: ImageDownloaderProtocol
    private let placeHolder = UIImage(named: "placeholder")
    private let notFoundedImage =  UIImage(named: "image_not_founded")
    let app: App
    var iconDelegate: AppIconDelegate?
    
    init(app: App,
         imageDownloader: ImageDownloaderProtocol,
         appDetailView: AppDetailViewProtocol) {
        self.app = app
        self.imageDownloader = imageDownloader
        self.appDetailView = appDetailView
    }
    
    func shouldDownloadImage() {
        guard let iconURL = app.iconURL, app.image == nil else {
            return
        }
        
        if let icon = imageDownloader.image(withIdentifier: iconURL.absoluteString) {
            app.image = icon
            appDetailView.downloadedAppImage()
            return
        }
        
        appDetailView.downloadingAppImage(image: placeHolder)
        let request = URLRequest(url: iconURL)
        
        imageDownloader.downloadImage(urlRequest: request) {
            [weak app, weak notFoundedImage] (iconImage, error) in
            guard let iconDownloaded = iconImage,
            let strongApp = app else {
                self.appDetailView.appImageNotDownloaded(image: notFoundedImage)
                return
            }
            strongApp.image = iconDownloaded
            self.iconDelegate?.appWasUpdated(app: strongApp)
            self.appDetailView.downloadedAppImage()            
        }
    }
    
}
