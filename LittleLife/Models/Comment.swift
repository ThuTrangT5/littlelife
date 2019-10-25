//
//  Comment.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class Comment: NSObject {

    var comment: String?
    var ownerID: NSNumber?
    var issueID: NSNumber?
    
    init(json: JSON) {
        super.init()
    }
}
