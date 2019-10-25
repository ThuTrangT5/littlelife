//
//  User.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class User: NSObject {

    var name: String?
    var avatarUrl: String?
    
    init(json: JSON) {
        super.init()
        
        name = json["login"].string
        avatarUrl = json["avatarUrl"].string
    }
}
