//
//  ListAppsViewController.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit
import AlamofireImage

class ListAppsViewController: UIViewController, BaseFlow {

    weak var appListView: AppListView!
    var listAppsPresenter: ListAppsPresenter!
    var flowDelegate: ListViewControllerFlowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        self.navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        flowDelegate?.prepare(for: segue, sender: sender)
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        flowDelegate?.categoryWasTouched(on: self)
    }

}

private extension ListAppsViewController {
    
    func setUpUI() {
        let listView = AppListView(tableDelegate: self,
                                   collectionDelegate: self)
        view.addSubview(listView)
        appListView = listView
    }
    
}

extension ListAppsViewController: AppListCollectionViewProtocol, AppListTableViewProtocol {
    
    var tableCellNibName: String {
        return AppTableViewCell.nibName
    }
    
    var tableCellReuseIdentifier: String {
        return AppTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAppsPresenter.appsForConsume.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let app = listAppsPresenter.appsForConsume[indexPath.row]
        let appImage = listAppsPresenter.getImageForApp(index: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier) as? AppTableViewCell else {
            return UITableViewCell()
        }
        
        fillAppTableCell(app: app,
                         appImage: appImage,
                         appCell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let app = listAppsPresenter.appsForConsume[indexPath.row]
        flowDelegate?.detailWasTouched(on: self, app: app)
    }
    
    func fillAppTableCell(app: App, appImage: UIImage?, appCell: AppTableViewCell) {
        appCell.appTitleLabel.text = app.shortName
        appCell.appTypeLabel.text = app.category
        appCell.appPriceLabel.text = app.price
        appCell.appArtistLabel.text = app.artist
        appCell.appIconImageView.image = appImage
    }
    
}

extension ListAppsViewController {

    var collectionCellNibName: String {
        return AppCollectionViewCell.nibName
    }
    
    var collectionCellReuseIdentifier: String {
        return AppCollectionViewCell.identifier
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return listAppsPresenter.appsForConsume.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let app = listAppsPresenter.appsForConsume[indexPath.row]
        let appImage = listAppsPresenter.getImageForApp(index: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCollectionViewCell.identifier,
                                                            for: indexPath) as? AppCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        fillAppCollectionCell(app: app,
                              appImage: appImage,
                              appCell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let app = listAppsPresenter.appsForConsume[indexPath.item]
        flowDelegate?.detailWasTouched(on: self, app: app)
    }
    
    func fillAppCollectionCell(app: App, appImage: UIImage?, appCell: AppCollectionViewCell) {
        appCell.appTitleLabel.text = app.shortName
        appCell.appIconImageView.image = appImage
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            appListView.shouldReload()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        appListView.shouldReload()
    }
    
}

extension ListAppsViewController: ListAppViewProtocol {

    func appIconDownloaded(index: IndexPath) {
        appListView?.shouldReloadContent(at: index)
    }
    
    func appIconNotDownloaded(index: IndexPath) {
        appListView?.shouldReloadContent(at: index)
    }
    
    func categoyWasSelected() {
        appListView.reload()
    }
    
}

//MARK: UINavigationController Delegate Methods

extension ListAppsViewController : UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(timeForTransition: 0.35, type: .fade)
    }
    
}
