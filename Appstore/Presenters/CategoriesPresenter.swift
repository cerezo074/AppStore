//
//  CategoriesPresenter.swift
//  Appstore
//
//  Created by eli on 2/14/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import UIKit

protocol CategoriesViewProtocol: class {
    func loadingCategories()
    func categoriesLoaded()
    func categoriesNotLoaded()
}

protocol CategoriesSortDelegate: class {
    var selectedCategory: String? { get }
    var allCategory: String { get }
    func categoryWasSelected(category: String)
}

class CategoriesPresenter {
    
    private unowned let categoriesView: CategoriesViewProtocol
    private let repositoryService: DiskRepositoryProtocol
    private(set) var categories: [String] = []
    fileprivate let indexForAllCategory = 0
    weak var sortDelegate: CategoriesSortDelegate?
    private let selectedCategoryColor = UIColor.red
    private let unSelectedCategoryColor = UIColor.black
    
    init(repositoryService: DiskRepositoryProtocol,
         categoriesView: CategoriesViewProtocol,
         sortDelegate: CategoriesSortDelegate) {
        self.repositoryService = repositoryService
        self.categoriesView = categoriesView
        self.sortDelegate = sortDelegate
    }
    
    func loadCategories() {
        self.categoriesView.loadingCategories()
        repositoryService.getCategories(completion: {
            [weak self] (categoriesFetched, error) in
            guard var categories = categoriesFetched as? [String],
            let allCategory = self?.sortDelegate?.allCategory,
            let indexForAllCategory = self?.indexForAllCategory else {
                self?.categoriesView.categoriesNotLoaded()
                return
            }
            categories.insert(allCategory, at: indexForAllCategory)
            self?.categories = categories
            self?.categoriesView.categoriesLoaded()
        })
    }
    
    func selectedCategory(at index: IndexPath) {
        let categorySelected = categories[index.row]
        sortDelegate?.categoryWasSelected(category: categorySelected)
    }
    
    func colorForCategory(at index: IndexPath) -> UIColor {
        return indexIsSelected(at: index) ? selectedCategoryColor : unSelectedCategoryColor
    }
    
}

private extension CategoriesPresenter {
    
    func getIndexForCategorySelected () -> IndexPath {
        let baseIndex = IndexPath(row: indexForAllCategory, section: 0)
        guard let categorySelected = sortDelegate?.selectedCategory else {
            return baseIndex
        }
        
        let indexBlock = { (category) -> Bool in
            category == categorySelected
        }
        
        guard let indexSelected = categories.index(where: indexBlock) else {
            return baseIndex
        }
        
        return IndexPath(row: indexSelected, section: 0)
    }
    
    func indexIsSelected(at index: IndexPath) -> Bool {
        return index == getIndexForCategorySelected()
    }
    
}
