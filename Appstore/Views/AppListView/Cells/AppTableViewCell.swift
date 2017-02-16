//
//  AppTableViewCell.swift
//  Appstore
//
//  Created by eli on 2/12/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell, AppListViewContentCell {

    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appTypeLabel: UILabel!
    @IBOutlet weak var appArtistLabel: UILabel!
    @IBOutlet weak var appPriceLabel: UILabel!
    @IBOutlet weak var appIconImageView: UIImageView!
    
    var appIconImage: UIImageView {
        return appIconImageView
    }
    
    class var identifier: String {
        return "AppTableViewCell"
    }
    
    class var nibName: String {
        return "AppTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 10
        separatorInset = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        appIconImageView.image = nil
    }
    
}
