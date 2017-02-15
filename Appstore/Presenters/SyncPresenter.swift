//
//  SyncPresenter.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation

protocol SycnViewProtocol: class {
    func downloadingData()
    func dataWasDownloaded(apps: [App])
    func dataNotDownloaded(errorMessage: String)
}

struct SyncPresenter {
    
    unowned let syncView: SycnViewProtocol
    let itunesService: ItunesServiceProtocol
    let repositoryService: DiskRepositoryProtocol
    
    init(syncView: SycnViewProtocol, itunesService: ItunesServiceProtocol, repositoryService: DiskRepositoryProtocol) {
        self.syncView = syncView
        self.itunesService = itunesService
        self.repositoryService = repositoryService
    }
    
    func downloadData() {
        syncView.downloadingData()
        itunesService.downloadApps(amount: 50) {
            response in
            switch response {
            case .success(apps: let apps):
                self.repositoryService.saveApps(apps: apps, completion: {
                    (result, errorDetail) in
                    guard let error = errorDetail else {
                        print("Data was saved!")
                        return
                    }
                    print("Error saving data: " + error.localizedDescription)
                })
                self.syncView.dataWasDownloaded(apps: apps)
                break
            case .notConnectedToInternet, .failure:
                guard let dataFromDisk = self.repositoryService.loadApps() else {
                    let messageToShow = response == .failure ? "There is an error please try later."
                        : "Sorry, you need an internet connection"
                    self.syncView.dataNotDownloaded(errorMessage: messageToShow)
                    return
                }
                self.syncView.dataWasDownloaded(apps: dataFromDisk)
            }
        }
    }
    
}
