//
//  SyncPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

protocol SycnViewProtocol {
    func downloadingData()
    func dataWasDownloaded(apps: [App])
    func dataNotDownloaded(errorMessage: String)
}

struct SyncPresenter {
    
    let view: SycnViewProtocol
    let itunesService: ItunesServiceProtocol
    let repositoryService: DiskRepositoryProtocol
    
    init(view: SycnViewProtocol, itunesService: ItunesServiceProtocol, repositoryService: DiskRepositoryProtocol) {
        self.view = view
        self.itunesService = itunesService
        self.repositoryService = repositoryService
    }
    
    func downloadData() {
        view.downloadingData()
        itunesService.downloadApps(amount: 10) { response in
            switch response {
            case .success(apps: let apps):
                self.repositoryService.saveApps(apps: apps, completion: { (result, errorDetail) in
                    guard let error = errorDetail else {
                        print("Data was saved!")
                        return
                    }
                    print("Error saving data: " + error.localizedDescription)
                })
                self.view.dataWasDownloaded(apps: apps)
                break
            case .notConnectedToInternet, .failure:
                guard let dataFromDisk = self.repositoryService.loadApps() else {
                    let messageToShow = response == .failure ? "There is an error please try later."
                        : "Sorry, you need an internet connection"
                    self.view.dataNotDownloaded(errorMessage: messageToShow)
                    return
                }
                self.view.dataWasDownloaded(apps: dataFromDisk)
            }
        }
    }
    
}
