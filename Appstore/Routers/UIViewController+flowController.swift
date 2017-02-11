//
//  UIViewController+flowController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    var flowController: AppstoreFlowController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let appStoreFlowController = appDelegate.appFlowController else {
                return nil
        }
        
        return appStoreFlowController
    }
    
}
