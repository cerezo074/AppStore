//
//  AppsDownloader.swift
//  Appstore
//
//  Created by eli on 2/11/17.
//  Copyright © 2017 Examples. All rights reserved.
//

import Foundation
import Alamofire

struct AppsDownloader: ItunesServiceProtocol {
    
    func downloadApps(amount: Int, completion: @escaping (AppStoreResponse) -> Void) {
        
        let numberOfApps = amount <= 0 ? 20 : amount
        Alamofire.request(Apps.get(amount: numberOfApps)).responseJSON {
            response in
            
            switch response.result {
            case let .success(result):
                if let json = result as? [String : Any],
                    let apps = self.responseParse(dict: json) {
                    completion(.success(apps: apps))
                } else {
                    completion(.failure)
                }
            case let .failure(responseError as NSError):
                if responseError.code == NSURLErrorNotConnectedToInternet {
                    return completion(.notConnectedToInternet)
                } else {
                    return completion(.failure)
                }
            default:
                completion(.failure)
            }
            
        }
        
    }
    
}

private extension AppsDownloader {

    enum Apps: URLRequestConvertible {
        
        case get(amount: Int)
        
        var fakeRequest: URLRequest {
            let badURL = URL(string: "http://badurl.com")!
            return URLRequest(url: badURL)
        }
        
        fileprivate func asURLRequest() throws -> URLRequest {
            
            let values: (path: String, method: Alamofire.HTTPMethod, parameters: [String : Any]?) = {
                
                switch self {
                case .get(let amount):
                    return (endPoint + "limit=\(amount)/json", .get, nil)
                }
                
            }()
            
            guard let url = URL(string: values.path) else {
                return fakeRequest
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = values.method.rawValue
            
            guard let result = try? Alamofire.URLEncoding().encode(urlRequest, with: values.parameters) else {
                return fakeRequest
            }
            
            return result
        }
    }
        
    static let endPoint = "https://itunes.apple.com/us/rss/topfreeapplications/"
    
    func responseParse(dict: [String : Any]) -> [App]? {
       
        guard let feed = dict["feed"] as? [String : Any],
            let entry = feed["entry"] as? [NSDictionary]
            else {
                return nil
        }
        
        var apps = [App]()
        
        for rawAppData in entry {
            let app = App(dict: rawAppData)
            apps.append(app)
        }
        
        return apps
    }
    
}
