//
//  User.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class User: BaseModel {

    var name: String?
    var avatarUrl: String?
    
    required init(json: JSON) {
        super.init(json: json)
        
        id = json["id"].string
        name = json["login"].string
        avatarUrl = json["avatarUrl"].string
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
