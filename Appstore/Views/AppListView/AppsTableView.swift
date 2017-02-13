//
//  AppsTableView.swift
//  Appstore
//
//  Created by eli on 2/13/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppsTableView: UITableView {

    weak var appsListDelegate: AppListTableViewProtocol?
    
    init(appsListDelegate: AppListTableViewProtocol,
         tableViewStyle style: UITableViewStyle) {
        
        self.appsListDelegate = appsListDelegate
        super.init(frame: CGRect.zero, style: style)
        
        dataSource = appsListDelegate
        delegate = appsListDelegate
        tableFooterView = UIView(frame: CGRect.zero)
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 90
        register(UINib.init(nibName: appsListDelegate.tableCellNibName, bundle: nil),
                           forCellReuseIdentifier: appsListDelegate.tableCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        baseLayout()
    }

}
