//
//  AppsCollectionView.swift
//  Appstore
//
//  Created by eli on 2/13/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppsCollectionView: UICollectionView {
    
    weak var appsListDelegate: AppListCollectionViewProtocol?
    
    init(appsListDelegate: AppListCollectionViewProtocol,
         collectionViewLayout layout: UICollectionViewLayout) {
        
        self.appsListDelegate = appsListDelegate
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        delegate = appsListDelegate
        dataSource = appsListDelegate
        backgroundColor = .white
        register(UINib.init(nibName: appsListDelegate.collectionCellNibName, bundle: nil),
                 forCellWithReuseIdentifier: appsListDelegate.collectionCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        baseLayout()
    }
    
}
