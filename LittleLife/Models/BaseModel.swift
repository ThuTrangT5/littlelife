//
//  BaseModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

open class BaseModel: NSObject {
    
    var id: String?
    var cursor: String?
    
    public override init() {
        super.init()
    }
    
    required public init(json: JSON) {
        super.init()
        
        id = json["id"].string
        cursor = json["cursor"].string
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func getArray<T: BaseModel>(json: JSON) -> [T] {
        
        var result: [T] = []
        let items = json.arrayValue
        for i in items {
            let model = T(json: i)
            result.append(model)
        }
        
        return result
    }
}

