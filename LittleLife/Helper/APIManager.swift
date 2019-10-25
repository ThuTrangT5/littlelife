//
//  RequestManager.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    
    static var shared: APIManager = APIManager()
    static private let endpoint = "https://api.github.com/graphql"
    static private let accessToken = "b6fbc3252b550837634d77dac415cf06f6115143"
    
    
    private func getHeader() -> HTTPHeaders {
        var token = ""
        
        // testing
        token = APIManager.accessToken
        
        if let accessToken = UserDefaults.standard.value(forKey: kAccessToken) as? String {
            token = accessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer \(token)",
            "Content-Type":"application/json;charset=utf-8"
        ]
        
        return headers
    }
    
    private func getQueryFromFile(fileName: String) -> String? {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: kqueryFileExtension) else {
            print("Can not FIND [\(fileName)]")
            return nil
        }
        
        guard let content = try? String(contentsOfFile: path) else {
            print("Can not READ [\(fileName)]")
            return nil
        }
        
        return content
    }
    
    private func sendRequest(query: String, callback: ((JSON, Error?)->Void)?) {
        let url = APIManager.endpoint
        let headers = self.getHeader()
        
        var repositoryQuery = query
        repositoryQuery = repositoryQuery.replacingOccurrences(of: "$owner", with: "\"\(kRepositoryOwner)\"")
        repositoryQuery = repositoryQuery.replacingOccurrences(of: "$respository", with: "\"\(kRepositoryName)\"")
        
        let params: [String: String] = [
            "query": repositoryQuery
        ]
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
            .responseJSON { response in
                
                if let error = response.error {
                    callback?(JSON.null, error)
                    
                } else if let value = response.value {
                    let json = JSON(value)
                    let data = json["data"]["repository"]
                    let errors = json["errors"]
                    
                    if data != JSON.null {
                        callback?(data, nil)
                        
                    } else if errors != JSON.null && errors.count > 0 {
                        let errorMessage = errors[0]["message"]
                        
                        let error = NSError(domain: NSURLErrorDomain,
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        callback?(JSON.null, error)
                        
                    } else if var message = json["message"].string {
                        message += "\nPlease check your Access Token."
                        let error = NSError(domain: NSURLErrorDomain,
                                            code: 401,
                                            userInfo: [NSLocalizedDescriptionKey: message])
                        callback?(JSON.null, error)
                    }
                }
        }
    }
    
    func getIssues(status: IssueStatus, after: String?, callback: (([Issue]?, Int, Error?) -> Void)?) {
        let queryFileName = "GetIssuesByPage"
        var query = self.getQueryFromFile(fileName: queryFileName) ?? ""
        
        query = query.replacingOccurrences(of: "$limit", with: "\(kPagingItemNumber)")
        if let afterCursor = after {
            query = query.replacingOccurrences(of: "$afterCursor", with: "\"\(afterCursor)\"")
        } else {
            query = query.replacingOccurrences(of: "affter: $afterCursor", with: "")
        }
        
        let state = status.rawValue
        if state.count > 0 && state != "all" {
            query = query.replacingOccurrences(of: "$status", with: state)
        } else {
            query = query.replacingOccurrences(of: "states: $status", with: "")
        }
        
        self.sendRequest(query: query) { (response, error) in
            print(response)
            
            if let error = error {
                callback?(nil, -1, error)
                
            } else {
                let totalCount = response["issues"]["totalCount"].intValue
                let issues: [Issue] = Issue.getArray(json: response["issues"]["edges"])
                callback?(issues, totalCount, nil)
            }
        }
    }
}
