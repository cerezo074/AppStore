//
//  BasicDAO.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import CoreData

protocol BasicDAO {
    typealias PerformTaskWithResultBlock = (_ result: Any?, _ error: Error?) -> Void
    typealias PerformTaskWithMultipleResultBlock = (_ result: [Any]?, _ error: Error?) -> Void
}

extension BasicDAO {

    func callOnMainThreadSimpleBlock(completionBlock: @escaping DiskRepositoryProtocol.PerformTaskBlock, result: Bool, error: Error?) {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                completionBlock(result, error)
            }
            return
        }
        completionBlock(result, error)
    }
    
    func callOnMainThreadResultBlock(completionBlock: @escaping DiskRepositoryProtocol.PerformTaskWithResultBlock, result: Any?, error: Error?) {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                completionBlock(result, error)
            }
            return
        }
        completionBlock(result, error)
    }
    
    func callOnMainThreadMultipleResultsBlock(completionBlock: @escaping DiskRepositoryProtocol.PerformTaskWithMultipleResultBlock, result: [Any]?, error: Error?) {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                completionBlock(result, error)
            }
            return
        }
        completionBlock(result, error)
    }
    
    func createRequestWith(_ entityName: String, _ predicateFormat: String, _ arguments: [Any]) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchedRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: arguments)
        
        return fetchedRequest
    }
    
    static func createError(_ descriptionMessage: String) -> Error {
        let descriptionDict = [NSLocalizedDescriptionKey : descriptionMessage]
        return NSError(domain: "BasicDAO", code: 1000, userInfo: descriptionDict)
    }
    
}
