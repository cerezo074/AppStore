//
//  AppListView.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppListView: UIView {
    
    fileprivate weak var appsTableView: AppsTableView?
    fileprivate weak var appsCollectionView: AppsCollectionView?
    fileprivate var failsIndexPendings: Set<IndexPath> = []
    
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
    
    func shouldReload() {
        var indexPreparedForLoad: Set<IndexPath> = []
        
        for failIndex in failsIndexPendings {
            if indexShouldReload(index: failIndex) {
                indexPreparedForLoad.insert(failIndex)
            }
        }
        
        if shouldUseTable() {
            appsTableView?.reloadRows(at: Array(indexPreparedForLoad), with: .fade)
        } else {
            appsCollectionView?.reloadItems(at: Array(indexPreparedForLoad))
        }
        
        failsIndexPendings = indexPreparedForLoad.subtracting(failsIndexPendings)
    }
    
    func reload() {
        if shouldUseTable() {
            appsTableView?.reloadData()
        } else {
            appsCollectionView?.reloadData()
        }
    }
    
    func shouldReloadContent(at index: IndexPath,
                             image: UIImage?) {
        if shouldUseTable() {
            guard let tableView = appsTableView,
                let visibleIndexes = tableView.indexPathsForVisibleRows,
                (!tableView.isDragging && !tableView.isDecelerating) else {
                    failsIndexPendings.insert(index)
                    return
            }
            
            let containIndexBlockOperation = { (indexToCompare: IndexPath) -> Bool in
                return indexToCompare.section == index.section &&
                    indexToCompare.row == index.row
            }
            
            if visibleIndexes.contains(where: containIndexBlockOperation) {
                guard let cell = tableView.cellForRow(at: index) as? AppListViewContentCell else {
                    print("Cell not conform AppListViewContentCell protocol, at index:\(index)")
                    return
                }
                failsIndexPendings.remove(index)
                cell.appIconImage.image = image
            }
        } else {
            guard let collectionView = appsCollectionView,
            (!collectionView.isDragging && !collectionView.isDecelerating)else {
                failsIndexPendings.insert(index)
                return
            }
            
            let visibleIndexes = collectionView.indexPathsForVisibleItems
            let containIndexBlockOperation = { (indexToCompare: IndexPath) -> Bool in
                return indexToCompare.section == index.section &&
                    indexToCompare.item == index.item
            }
            
            if visibleIndexes.contains(where: containIndexBlockOperation) {
                guard let cell = collectionView.cellForItem(at: index) as? AppListViewContentCell else {
                    print("Cell not conform AppListViewContentCell protocol, at index:\(index)")
                    return
                }
                cell.appIconImage.image = image
                failsIndexPendings.remove(index)
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

    func indexShouldReload(index: IndexPath) -> Bool {
        if failsIndexPendings.contains(index) {
            if let visibleIndexesPaths = appsTableView?.indexPathsForVisibleRows {
                return visibleIndexesPaths.contains(index)
            }
            
            if let visibleIndexesPaths = appsCollectionView?.indexPathsForVisibleItems {
                return visibleIndexesPaths.contains(index)
            }
        }
        
        return false
    }
    
}
