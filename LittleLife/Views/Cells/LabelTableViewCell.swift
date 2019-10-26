//
//  LabelTableViewCell.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    
    var item: Label? {
        didSet {
            self.bindData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
    }
    
    func bindData() {
        if let text = item?.name {
            self.labelText.text = "   \(text)   "
        }
        
        if let color = item?.color {
            self.labelText.backgroundColor = UIColor(hexString: color)
        } else {
            self.labelText.backgroundColor = kTintColor
        }
    }
}
