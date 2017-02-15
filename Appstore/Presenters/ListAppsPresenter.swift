//
//  ListAppsPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol ListAppViewProtocol: class {
    func appIconDownloaded(index: IndexPath)
    func appIconNotDownloaded(index: IndexPath)
}

struct ListAppsPresenter {
    
    fileprivate unowned let listAppView: ListAppViewProtocol
    private(set) var apps: [App]
    private let imageDownloader: ImageDownloaderProtocol
    private let placeHolder = UIImage(named: "placeholder")
    private let notFoundedImage =  UIImage(named: "image_not_founded")
    
    init(apps: [App], listAppView: ListAppViewProtocol,imageDownloader: ImageDownloaderProtocol) {
        self.apps = apps
        self.imageDownloader = imageDownloader
        self.listAppView = listAppView
    }
    
    func getImageForApp(index: IndexPath) -> UIImage? {
        let app = apps[index.row]

        guard let iconURL = apps[index.row].iconURL else {
            return placeHolder
        }
        
        let iconUrlRequest = URLRequest(url: iconURL)
        
        guard let icon = imageDownloader.image(withIdentifier: iconURL.absoluteString) else {
            imageDownloader.downloadImage(urlRequest: iconUrlRequest, completionBlock: {
                [weak app, weak notFoundedImage] (iconImage, error) in
                guard let image = iconImage else {
                    app?.image = notFoundedImage
                    self.listAppView.appIconNotDownloaded(index: index)
                    return
                }
                app?.image = image
                self.listAppView.appIconDownloaded(index: index)
            })
            
            return placeHolder
        }
        
        return icon
    }
    
}


extension ListAppsPresenter: AppIconDelegate {
    
    func appWasUpdated(app: App) {
        guard let index = indexForApp(appId: app.appstoreID) else {
            return
        }
        
        let indexPath = UIDevice.current.userInterfaceIdiom == .phone ?
            IndexPath(row: index, section: 0) : IndexPath(item: index, section: 0)
        listAppView.appIconDownloaded(index: indexPath)
    }
    
    func indexForApp(appId: String) -> Int? {
        return apps.index { (app) -> Bool in
            return app.appstoreID == appId
        }
    }
    
}
