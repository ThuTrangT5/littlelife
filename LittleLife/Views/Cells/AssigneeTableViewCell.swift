//
//  AssigneeTableViewCell.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import Kingfisher

class AssigneeTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewAssigneeAvatar: UIImageView!
    @IBOutlet weak var labelAssigneeName: UILabel!
    
    var item: User? {
        didSet {
            self.bindData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        imageViewAssigneeAvatar.layer.cornerRadius = imageViewAssigneeAvatar.frame.height / 2
        imageViewAssigneeAvatar.layer.masksToBounds = true
    }
    
    func bindData() {
        imageViewAssigneeAvatar.kf.cancelDownloadTask()
        
        if let link = item?.avatarUrl,
            let url = URL(string: link) {
            imageViewAssigneeAvatar.kf.setImage(with: url)
        }
        
        self.labelAssigneeName.text = item?.name
    }
}
