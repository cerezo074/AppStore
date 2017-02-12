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
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard let identifier = segue.identifier else { return }
        let destination = segue.destination
        let source = segue.source
        
        switch identifier {
        case Segues.listApps:
            guard let apps = sender as? [App] else { break }
            prepareForListApps(with: apps, destinationVC: destination)
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
        syncVC.flowDelegate = self
        let itunesServer = AppsDownloader()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let appsCoreDataStack = appDelegate.appsCoreDataStack else {
                return
        }
        
        let repositoryServer = AppsCoreDataDAO(dataSource: appsCoreDataStack)
        let syncPresenter = SyncPresenter(view: syncVC,
                                      itunesService: itunesServer,
                                      repositoryService: repositoryServer)
        syncVC.syncPresenter = syncPresenter
    }
    
    func prepareForListApps(with apps: [App], destinationVC: UIViewController) {
        hideNavBar(hide: false)
        guard let listAppsVC = destinationVC as? ListAppsViewController else { return }

        let listAppsPresenter = ListAppsPresenter(apps: apps)
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

extension AppstoreFlowController: SyncViewControllerFlowDelegate {
    func appWasSynced(on syncVC: SyncViewController, apps: [App]) {
        syncVC.performSegue(withIdentifier: Segues.listApps, sender: apps)
    }
}
