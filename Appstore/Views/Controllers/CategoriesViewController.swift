//
//  CategoriesViewController.swift
//  Appstore
//
//  Created by eli on 2/14/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, BaseFlow {

    @IBOutlet weak var categoriesTableView: UITableView!
    var categoriesPresenter: CategoriesPresenter!
    var flowDelegate: CategoriesViewControllerFlowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoriesPresenter.loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CategoriesViewController: CategoriesViewProtocol {
    
    func categoriesLoaded() {
        categoriesTableView.reloadData()
    }
    
    func categoriesNotLoaded() {
        
    }
    
    func loadingCategories() {
        
    }
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesPresenter.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let basicIdentifier = "cell"
        let category = categoriesPresenter.categories[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: basicIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: basicIdentifier)
        }
        
        cell?.textLabel?.text = category
        cell?.textLabel?.textColor = categoriesPresenter.colorForCategory(at: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        categoriesPresenter.selectedCategory(at: indexPath)
        flowDelegate?.userHasSelectedCategory(on: self)
    }
    
}
