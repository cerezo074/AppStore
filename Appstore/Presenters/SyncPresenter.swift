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
        itunesService.downloadApps(amount: 50) { response in
            switch response {
            case .success(apps: let apps):
                self.repositoryService.saveApps(app: apps, completion: { (result) in
                    switch result {
                    case .error(let message):
                        print("Error saving data: " + message)
                        break
                    case .success:
                        print("Data was saved!")
                        break
                    }
                    self.view.dataWasDownloaded(apps: apps)
                })
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
