//
//  SyncViewController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {

    var syncPresenter: SyncPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncPresenter.downloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        flowController?.prepareForSegue(segue: segue)
    }

}

extension SyncViewController: SycnViewProtocol {

    func downloadingData() {
        print("Dowloading data")
    }
    
    func dataWasDownloaded(apps: [App]) {
        print("Data was downloaded \(apps)")
    }
    
    func dataNotDownloaded(errorMessage: String) {
        print("Data can't be downloaded \(errorMessage)")
    }
    
}

struct fakeRepositoryServer: DiskRepositoryProtocol {

    func saveApps(app: [App], completion: (DataSaveResult) -> Void) {
        completion(.success)
    }
    
    func loadApps() -> [App]? {
        return [App.DemoApp()]
    }
    
}
