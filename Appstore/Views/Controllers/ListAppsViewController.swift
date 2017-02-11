//
//  ListAppsViewController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class ListAppsViewController: UIViewController {

    var listAppsPresenter: ListAppsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        flowController?.prepareForSegue(segue: segue)
    }

}
