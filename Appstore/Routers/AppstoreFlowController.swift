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
    let imageDownloaderServer = AlamofireImageDownloader()
    
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
            guard let app = sender as? App else { break }
            prepareForDetail(with: app,sourceVC: source, destinationVC: destination)
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
        listAppsVC.navigationItem.hidesBackButton = true
        listAppsVC.flowDelegate = self
        let listAppsPresenter = ListAppsPresenter(apps: apps,
                                                  listAppView: listAppsVC,
                                                  imageDownloader: imageDownloaderServer)
        listAppsVC.listAppsPresenter = listAppsPresenter
    }
    
    func prepareForDetail(with app: App, sourceVC: UIViewController, destinationVC: UIViewController) {
        hideNavBar(hide: true)
        guard let appDetailVC = destinationVC as? AppDetailViewController else { return }
        guard let listAppsVC = sourceVC as? ListAppsViewController else { return }
        
        var appDetailPresenter = AppDetailPresenter(app: app, imageDownloader: imageDownloaderServer, appDetailView: appDetailVC)
        appDetailVC.flowDelegate = self
        appDetailPresenter.iconDelegate = listAppsVC.listAppsPresenter
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

extension AppstoreFlowController: ListViewControllerFlowDelegate {
    func detailWasTouched(on listVC: ListAppsViewController, app: App) {
        listVC.performSegue(withIdentifier: Segues.appDetail, sender: app)
    }
}

extension AppstoreFlowController: AppDetailViewControllerFlowDelegate {
    func userPressBackButton(on appDetail: AppDetailViewController) {
        guard let navVC = appDetail.navigationController else { return }
        navVC.popViewController(animated: true)
        hideNavBar(hide: false)
    }
}
