//
//  FlowDelegate.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol BaseFlow {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol BaseFlowViewController {
    var flowDelegate: BaseFlow? { get set }
}

protocol SyncViewControllerFlowDelegate: BaseFlow {
    func appWasSynced(on syncVC: SyncViewController, apps: [App])
}

protocol ListViewControllerFlowDelegate: BaseFlow {
    func detailWasTouched(on listVC: ListAppsViewController, app: App)
    func categoryWasTouched(on listVC: ListAppsViewController)
}

protocol AppDetailViewControllerFlowDelegate: BaseFlow {
    func userPressBackButton(on appDetail: AppDetailViewController)
}

protocol CategoriesViewControllerFlowDelegate: BaseFlow {
    func userHasSelectedCategory(on categoyVC: CategoriesViewController)
}
