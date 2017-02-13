//
//  AppListView.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppListView: UIView {
    
    private weak var appsTableView: AppsTableView?
    private weak var appsCollectionView: AppsCollectionView?
    
    init(tableDelegate: AppListTableViewProtocol,
         collectionDelegate: AppListCollectionViewProtocol) {
        
        super.init(frame: CGRect.zero)
        
        if shouldUseTable() {
            let tableView = AppsTableView(appsListDelegate: tableDelegate, tableViewStyle: .plain)
            addSubview(tableView)
            appsTableView = tableView
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 134, height: 149)
            layout.scrollDirection = .vertical
            let collectionView = AppsCollectionView(appsListDelegate: collectionDelegate,
                                                    collectionViewLayout: layout)
            addSubview(collectionView)
            appsCollectionView = collectionView
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func shouldReloadContent(at index: IndexPath) {
        
        if shouldUseTable() {
            guard let tableView = appsTableView,
                let visibleIndexes = tableView.indexPathsForVisibleRows,
                (!tableView.isDragging && !tableView.isDecelerating) || tableView.isTracking else {
                        return
            }
            
            let containIndexBlockOperation = { (indexToCompare: IndexPath) -> Bool in
                return indexToCompare.section == index.section &&
                    indexToCompare.row == index.row
            }
            
            if visibleIndexes.contains(where: containIndexBlockOperation) {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        } else {
            guard let collectionView = appsCollectionView else {
                return
            }
            
            let visibleIndexes = collectionView.indexPathsForVisibleItems
            let containIndexBlockOperation = { (indexToCompare: IndexPath) -> Bool in
                return indexToCompare.section == index.section &&
                    indexToCompare.item == index.item
            }
            
            if visibleIndexes.contains(where: containIndexBlockOperation) {
                collectionView.reloadItems(at: [index])
            }
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        baseLayout()
    }
    
}

private extension AppListView {

    func shouldUseTable() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

}
