//
//  App.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

struct App {
    
    var appstoreID: String = ""
    var shortName: String = ""
    var detailName: String = ""
    var artist: String = ""
    var category: String = ""
    var releaseDate: String = ""
    var summary: String = ""
    var rights: String = ""
    var price: String = ""
    var iconURL: URL?
    var image: UIImage?
    
    init() {
        
    }
    
    init(dict: NSDictionary) {
        
        if let appstoreID = dict.value(forKeyPath: "id.attributes.im:id") as? String {
            self.appstoreID = appstoreID
        }
        
        if let shortName = dict.value(forKeyPath: "im:name.label") as? String {
            self.shortName = shortName
        }
        
        if let detailName = dict.value(forKeyPath: "title.label") as? String {
            self.detailName = detailName
        }
        
        if let artist = dict.value(forKeyPath: "im:artist.label") as? String {
            self.artist = artist
        }
        
        if let category = dict.value(forKeyPath: "category.attributes.term") as? String {
            self.category = category
        }
        
        if let releaseDate = dict.value(forKeyPath: "im:releaseDate.attributes.label") as? String {
            self.releaseDate = releaseDate
        }
        
        if let summary = dict.value(forKeyPath: "summary.label") as? String {
            self.summary = summary
        }
        
        if let rights = dict.value(forKeyPath: "rights.label") as? String {
            self.rights = rights
        }
        
        if let price = dict.value(forKeyPath: "im:price.attributes.amount") as? String,
            let priceUnit = dict.value(forKeyPath: "im:price.attributes.currency") as? String {
            self.price = price + " " + priceUnit
        }
        
        if let images = dict.value(forKeyPath: "im:image") as? [[String: Any]],
            let imageURLString = images.last?["label"] as? String,
            let iconURL = URL(string: imageURLString) {
            self.iconURL = iconURL
        }
        
    }
    
    static func DemoApp() -> App {
        return App(dict: ["im:name.label" : "Demo App ;)"])
    }
    
}

extension App: Equatable {
    static func ==(left: App, right: App) -> Bool {
        return left.appstoreID == right.appstoreID
    }
}
