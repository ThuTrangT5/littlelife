//
//  IssueLabel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class Label: BaseModel {

    var name: String?
    var color: String?
    
    required init(json: JSON) {
        super.init(json: json)
        
        name = json["name"].string
        color = json["color"].string
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
