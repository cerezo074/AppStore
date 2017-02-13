//
//  AppListViewProtocol.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func baseLayout() {
        
        guard let superView = superview else {
            print("Layout can't be configured on view: \(self)")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["view": self]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: viewsDict)
        superView.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: viewsDict)
        superView.addConstraints(verticalConstraints)
    }
    
}

protocol AppListTableViewProtocol: UITableViewDataSource, UITableViewDelegate {
    var tableCellReuseIdentifier: String { get }
    var tableCellNibName: String { get }
}

protocol AppListCollectionViewProtocol: UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionCellReuseIdentifier: String { get }
    var collectionCellNibName: String { get }
}
