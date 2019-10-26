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
    
    private func getHeader(accessToken: String? = nil) -> HTTPHeaders {
        var token = ""
        
        // testing
        
        if let accessToken = accessToken {
            token = accessToken
        } else if let storedAccessToken = UserDefaults.standard.value(forKey: kAccessToken) as? String {
            token = storedAccessToken
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
    
    private func sendRequest(query: String, accessToken: String? = nil, callback: ((JSON, Error?)->Void)?) {
        
        guard query.count > 0 else {
            let message = "Can not send request with a null query.\nPlease check your query file."
            let error = NSError(domain: NSURLErrorDomain,
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: message])
            callback?(JSON.null, error)
            return
        }
        
        let url = APIManager.endpoint
        let headers = self.getHeader(accessToken: accessToken)
        
        var repositoryQuery = query
        repositoryQuery = repositoryQuery.replacingOccurrences(of: "$owner", with: "\"\(kRepositoryOwner)\"")
        repositoryQuery = repositoryQuery.replacingOccurrences(of: "$respository", with: "\"\(kRepositoryName)\"")
        
        let params: [String: String] = [
            "query": repositoryQuery
        ]
        
        print("QUERY: \(repositoryQuery)")
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
            .responseJSON { response in
                
                if let error = response.error {
                    callback?(JSON.null, error)
                    
                } else if let value = response.value {
                    let json = JSON(value)
                    let data = (json["data"]["repository"] == JSON.null)
                        ? json["data"]
                        : json["data"]["repository"]
                    let errors = json["errors"]
                    
                    if errors != JSON.null && errors.count > 0 {
                        let errorMessage = errors[0]["message"].stringValue
                        
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
                        
                    }  else if data != JSON.null {
                        callback?(data, nil)
                    }
                }
        }
    }
    
    func login(accessTopken: String, callback:((User?, Error?)->Void)?) {
        let queryFileName = "Login"
        let query = self.getQueryFromFile(fileName: queryFileName) ?? ""
        
        self.sendRequest(query: query, accessToken: accessTopken) { (response, error) in
            
            if let error = error {
                callback?(nil, error)
                
            } else if response["viewer"] != JSON.null {
                let json = response["viewer"]
                let user: User = User(json: json)
                callback?(user, nil)
                
            } else {
                callback?(nil, nil)
            }
        }
    }
    
    func getIssues(status: IssueStatus, after: String?, callback: (([Issue]?, Int, String?, Error?) -> Void)?) {
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
                callback?(nil, -1, nil, error)
                
            } else {
                let totalCount = response["issues"]["totalCount"].intValue
                let endCursor = response["issues"]["pageInfo"]["endCursor"].string
                let nodes = response["issues"]["nodes"]
                let issues: [Issue] = Issue.getArray(json: nodes)
                callback?(issues, totalCount, endCursor, nil)
            }
        }
    }
    
    func getIssueDetail(issueNumber: NSNumber, callback: ((Issue?, Error?)->Void)?) {
        let queryFileName = "GetIssueDetail"
        var query = self.getQueryFromFile(fileName: queryFileName) ?? ""
        query = query.replacingOccurrences(of: "$issueNumber", with: issueNumber.stringValue)
        
        self.sendRequest(query: query) { (response, error) in
            print(response)
            
            if let error = error {
                callback?(nil, error)
                
            } else if response["issue"] != JSON.null {
                let issue = Issue(json: response["issue"])
                callback?(issue, nil)
                
            } else {
                let message = "Can not fin information of this issue.\nPlease try again"
                let error = NSError(domain: NSURLErrorDomain,
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: message])
                callback?(nil, error)
            }
        }
    }
}
