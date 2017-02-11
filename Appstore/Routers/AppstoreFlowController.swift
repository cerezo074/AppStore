//
//  AppstoreFlowController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

struct AppstoreFlowController {

    let rootVC: UIViewController
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
        setInitialRootVC()
    }
    
    func setInitialRootVC() {
        prepareForSync()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue) {
    
        guard let identifier = segue.identifier else { return }
        let destination = segue.destination
        let source = segue.source
        
        switch identifier {
        case Segues.listApps:
            prepareForListApps(sourceVC: source, destinationVC: destination)
            break
        case Segues.appDetail:
            prepareForDetail(sourceVC: source, destinationVC: destination)
        default:
            return
        }
        
    }
    
}

private extension AppstoreFlowController {

    func prepareForSync() {
        guard let navVC = rootVC as? UINavigationController,
        let syncVC = navVC.viewControllers.first as? SyncViewController else {
            return
        }
        
        navVC.isNavigationBarHidden = true
        
        let itunesServer = AppsDownloader()
        let repositoryServer = fakeRepositoryServer()
        let syncPresenter = SyncPresenter(view: syncVC,
                                      itunesService: itunesServer,
                                      repositoryService: repositoryServer)
        syncVC.syncPresenter = syncPresenter
    }
    
    func prepareForListApps(sourceVC: UIViewController, destinationVC: UIViewController) {
        hideNavBar(hide: false)
        guard let listAppsVC = destinationVC as? ListAppsViewController else { return }
        let listAppsPresenter = ListAppsPresenter()
        listAppsVC.listAppsPresenter = listAppsPresenter
    }
    
    func prepareForDetail(sourceVC: UIViewController, destinationVC: UIViewController) {
        guard let appDetailVC = destinationVC as? AppDetailViewController else { return }
        let appDetailPresenter = AppDetailPresenter()
        appDetailVC.appDetailPresenter = appDetailPresenter
    }
    
    func hideNavBar(hide: Bool) {
        guard let navVC = rootVC as? UINavigationController else {
            return
        }
        navVC.isNavigationBarHidden = hide
    }
    
}
