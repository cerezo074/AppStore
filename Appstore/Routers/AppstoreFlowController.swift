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
            prepareForListApps(with: apps,
                               destinationVC: destination)
            break
        case Segues.appDetail:
            guard let app = sender as? App else { break }
            prepareForDetail(with: app,
                             sourceVC: source,
                             destinationVC: destination)
            break
        case Segues.categories:
            prepareForCategories(sourceVC: source,
                                 destinationVC: destination)
            break
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
        
        let itunesServer = AppsDownloader()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let appsCoreDataStack = appDelegate.appsCoreDataStack else {
                return
        }
        
        let repositoryServer = AppsCoreDataDAO(dataSource: appsCoreDataStack)
        let syncPresenter = SyncPresenter(syncView: syncVC,
                                          itunesService: itunesServer,
                                          repositoryService: repositoryServer)
        
        syncVC.syncPresenter = syncPresenter
        navVC.isNavigationBarHidden = true
        syncVC.flowDelegate = self
    }
    
    func prepareForListApps(with apps: [App], destinationVC: UIViewController) {
        guard let listAppsVC = destinationVC as? ListAppsViewController else { return }

        let listAppsPresenter = ListAppsPresenter(apps: apps,
                                                  listAppView: listAppsVC,
                                                  imageDownloader: imageDownloaderServer)
        listAppsVC.listAppsPresenter = listAppsPresenter
        
        hideNavBar(hide: false)
        listAppsVC.navigationItem.hidesBackButton = true
        listAppsVC.flowDelegate = self
    }
    
    func prepareForDetail(with app: App, sourceVC: UIViewController, destinationVC: UIViewController) {
        guard let appDetailVC = destinationVC as? AppDetailViewController else { return }
        guard let listAppsVC = sourceVC as? ListAppsViewController else { return }
        
        var appDetailPresenter = AppDetailPresenter(app: app,
                                                    imageDownloader: imageDownloaderServer,
                                                    appDetailView: appDetailVC)
        appDetailPresenter.iconDelegate = listAppsVC.listAppsPresenter
        
        appDetailVC.appDetailPresenter = appDetailPresenter
        hideNavBar(hide: true)
        appDetailVC.flowDelegate = self
    }
    
    func prepareForCategories(sourceVC: UIViewController, destinationVC: UIViewController){
        guard let navVC = destinationVC as? UINavigationController,
        let categoriesVC = navVC.viewControllers.first as? CategoriesViewController else {
            return
        }
        guard let listAppsVC = sourceVC as? ListAppsViewController else { return }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let appsCoreDataStack = appDelegate.appsCoreDataStack else {
                return
        }
        
        let repositoryServer = AppsCoreDataDAO(dataSource: appsCoreDataStack)
        let categoriesPresenter = CategoriesPresenter(repositoryService: repositoryServer,
                                                      categoriesView: categoriesVC,
                                                      sortDelegate: listAppsVC.listAppsPresenter)
        categoriesVC.categoriesPresenter = categoriesPresenter
        categoriesVC.flowDelegate = self
//        let newAnchorViewPoint = listAppsVC.view.center
//        navVC.popoverPresentationController.
//        navVC.popoverPresentationController?.sourceRect = CGRect(x: newAnchorViewPoint.x, y: newAnchorViewPoint.y, width: navVC.view.bounds.width, height: navVC.view.bounds.height)
//        navVC.popoverPresentationController?.sourceRect = CGRect(x:newAnchorViewPoint.x, y:newAnchorViewPoint.y, width: 0, height: 0)
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
    
    func categoryWasTouched(on listVC: ListAppsViewController) {
        listVC.performSegue(withIdentifier: Segues.categories, sender: nil)
    }
}

extension AppstoreFlowController: AppDetailViewControllerFlowDelegate {
    func userPressBackButton(on appDetail: AppDetailViewController) {
        guard let navVC = appDetail.navigationController else { return }
        navVC.popViewController(animated: true)
        hideNavBar(hide: false)
    }
}

extension AppstoreFlowController: CategoriesViewControllerFlowDelegate {
    func userHasSelectedCategory(on categoyVC: CategoriesViewController) {
        categoyVC.dismiss(animated: true, completion: nil)
    }
}
