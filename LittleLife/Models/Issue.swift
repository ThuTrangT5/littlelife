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
    
    var title: String?
    var status: IssueStatus = .open
    
    var ownerID: NSNumber?
    var authorLogin: String?
    var assigneeID: NSNumber?
    
    var createdAt: String?
    var totalComments: Int = 0

    required init(json: JSON) {
        super.init()
        
        title = json["node"]["title"].string
        if let value = json["node"]["state"].string {
            status = IssueStatus(string: value)
        }
        
        authorLogin = json["author"]["login"].string
        
        createdAt = json["node"]["createdAt"].string?.suffix(10)
        totalComments = json["node"]["comments"]["totalCount"].intValue
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
