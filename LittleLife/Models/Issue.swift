//
//  IssueModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import SwiftyJSON

enum IssueStatus: String {
    case open = "OPEN"
    case close = "CLOSED"
    case all
    
    init(string: String) {
        if string == IssueStatus.open.rawValue {
            self = IssueStatus.open
            
        } else if string == IssueStatus.close.rawValue {
            self = IssueStatus.close
            
        } else {
            self = IssueStatus.all
        }
    }
}

class Issue: BaseModel {
    
    var number: NSNumber?
    var title: String?
    var status: IssueStatus = .open
    
    var author: User?
    var assignees: [User] = []
    
    var createdAt: String?
    var closedAt: String?
    var totalComments: Int = 0
    
    var comments: [Comment] = []
    var labels: [Label] = []
    
    required init(json: JSON) {
        super.init()
        
        number = json["number"].number
        title = json["title"].string
        if let value = json["state"].string {
            status = IssueStatus(string: value)
        }
        
        if json["author"] != JSON.null {
            author = User(json: json["author"])
        }
        
        if json["assignees"] != JSON.null {
            assignees = User.getArray(json: json["assignees"]["nodes"])
        }
        
        if let date = json["createdAt"].string?.prefix(10) {
            createdAt = String(date)
        }
        
        if let date = json["closedAt"].string?.prefix(10) {
            closedAt = String(date)
        }
        
        totalComments = json["comments"]["totalCount"].intValue
        
        if json["comments"] != JSON.null {
            comments = Comment.getArray(json: json["comments"]["nodes"])
        }
        
        if json["labels"] != JSON.null {
            labels = Label.getArray(json: json["labels"]["nodes"])
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
