//
//  AppDetailViewController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appArtistLabel: UILabel!
    @IBOutlet weak var appCategoryLabel: UILabel!
    @IBOutlet weak var appSummaryLabel: UILabel!
    @IBOutlet weak var appPriceLabel: UILabel!
    @IBOutlet weak var appRightsLabel: UILabel!
    
    var appDetailPresenter: AppDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appImageView.image = appDetailPresenter.app.image
        appTitleLabel.text = appDetailPresenter.app.shortName
        appArtistLabel.text = appDetailPresenter.app.artist
        appCategoryLabel.text = appDetailPresenter.app.category
        appPriceLabel.text = appDetailPresenter.app.price
        appRightsLabel.text = appDetailPresenter.app.rights
        appSummaryLabel.text = appDetailPresenter.app.summary
        
        appDetailPresenter.shouldDownloadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Methods
    
    @IBAction func backButtonPressed(_ sender: Any) {
        guard let navVC = navigationController else { return }
        navVC.popViewController(animated: true)
    }

}

extension AppDetailViewController: AppDetailViewProtocol {
    
    func appImageNotDownloaded(image badImage: UIImage?) {
        appImageView.image = badImage
    }
    
    func downloadingAppImage(image placeHolder: UIImage?) {
        appImageView.image = placeHolder
    }
    
    func downloadedAppImage() {
        appImageView.image = appDetailPresenter.app.image
    }
    
}
