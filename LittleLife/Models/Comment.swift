//
//  Comment.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class Comment: BaseModel {

    var comment: String?
    var publishedAt: String?
    var updatedAt: String?
    
    var author: User?
    
    required init(json: JSON) {
        super.init(json: json)
        
        comment = json["bodyText"].string
        
        if let date = json["publishedAt"].string?.prefix(10) {
            publishedAt = String(date)
        }
        
        if let date = json["updatedAt"].string?.prefix(10) {
            updatedAt = String(date)
        }
        
        if json["author"] != JSON.null {
            author = User(json: json["author"])
        }        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
