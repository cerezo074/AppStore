//
//  ListAppsPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol ListAppViewProtocol {
    func appIconDownloaded(index: IndexPath)
    func appIconNotDownloaded(index: IndexPath)
}

struct ListAppsPresenter {
    
    private(set) var apps: [App]
    private let imageDownloader: ImageDownloaderProtocol
    fileprivate let listAppView: ListAppViewProtocol
    fileprivate let placeHolder = UIImage(named: "placeholder")
    fileprivate let notFoundedImage =  UIImage(named: "image_not_founded")
    
    init(apps: [App], listAppView: ListAppViewProtocol,imageDownloader: ImageDownloaderProtocol) {
        self.apps = apps
        self.imageDownloader = imageDownloader
        self.listAppView = listAppView
    }
    
    func getImageForApp(index: IndexPath) -> UIImage? {
        guard let iconURL = apps[index.row].iconURL else {
            return placeHolder
        }
        
        let iconUrlRequest = URLRequest(url: iconURL)
        
        guard let icon = imageDownloader.image(withIdentifier: iconURL.absoluteString) else {
            imageDownloader.downloadImage(urlRequest: iconUrlRequest, completionBlock: {
                (iconImage, error) in
                guard let image = iconImage else {
                    self.setImageNotFound(at: index.row)
                    self.listAppView.appIconNotDownloaded(index: index)
                    return
                }
                
                self.setImage(on: index.row, image: image)
                self.listAppView.appIconDownloaded(index: index)
            })
            
            return placeHolder
        }
        
        return icon
    }
    
}

private extension ListAppsPresenter {
    
    func setImage(on appIndex: Int, image: UIImage) {
        var app = apps[appIndex]
        app.image = image
    }
    
    func setImageNotFound(at appIndex: Int) {
        var app = apps[appIndex]
        app.image = notFoundedImage
    }
    
}

extension ListAppsPresenter: AppIconDelegate {
    
    func appWasUpdated(app: App) {
        guard let index = indexForApp(appId: app.appstoreID) else {
            return
        }
        
        var appOutDated = apps[index]
        appOutDated.image = app.image
        
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
