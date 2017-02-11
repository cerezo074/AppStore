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
    
    func prepareForListApps(sourceVC: UIViewController, destinationVC: UIViewController) {
        guard let listAppsVC = destinationVC as? ListAppsViewController else { return }
        let listAppsPresenter = ListAppsPresenter()
        listAppsVC.listAppsPresenter = listAppsPresenter
    }
    
    func prepareForDetail(sourceVC: UIViewController, destinationVC: UIViewController) {
        guard let appDetailVC = destinationVC as? AppDetailViewController else { return }
        let appDetailPresenter = AppDetailPresenter()
        appDetailVC.appDetailPresenter = appDetailPresenter
    }
    
}
