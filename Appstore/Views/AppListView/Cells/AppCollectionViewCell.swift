//
//  AppCollectionViewCell.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell, AppListViewContentCell{

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    
    var appIconImage: UIImageView {
        return appIconImageView
    }
    
    class var identifier: String {
        return "AppCollectionViewCell"
    }
    
    class var nibName: String {
        return "AppCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        appIconImageView.image = nil
    }

}
