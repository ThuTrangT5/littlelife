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
    
    var author: User?
    
    required init(json: JSON) {
        super.init()
        
        comment = json["bodyText"].string
        
        if let date = json["node"]["createdAt"].string?.suffix(10) {
            publishedAt = String(date)
        }
        
        if json["author"] != JSON.null {
            author = User(json: json["author"])
        }        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
