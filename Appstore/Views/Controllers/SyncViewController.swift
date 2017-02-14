//
//  SyncViewController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController, BaseFlow {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusActivityIndicator: UIActivityIndicatorView!
    var flowDelegate: SyncViewControllerFlowDelegate?
    var syncPresenter: SyncPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncPresenter.downloadData()
        self.navigationController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        flowDelegate?.prepare(for: segue, sender: sender)
    }

}

extension SyncViewController: SycnViewProtocol {

    func downloadingData() {
        statusLabel.text = "Dowloading data"
        statusActivityIndicator.startAnimating()
        statusActivityIndicator.isHidden = false
    }
    
    func dataWasDownloaded(apps: [App]) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.statusLabel.text = "Data was loaded"
            self.statusActivityIndicator.stopAnimating()
            self.statusActivityIndicator.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            [weak self] in
            guard let `self` = self else { return }
            self.flowDelegate?.appWasSynced(on: self, apps: apps)
        }
    }
    
    func dataNotDownloaded(errorMessage: String) {
        statusLabel.text = "Data can't be downloaded \(errorMessage)"
        statusActivityIndicator.stopAnimating()
        statusActivityIndicator.isHidden = true
    }
    
}

extension SyncViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(timeForTransition: 3.0, type: .bounce)
    }
    
}
