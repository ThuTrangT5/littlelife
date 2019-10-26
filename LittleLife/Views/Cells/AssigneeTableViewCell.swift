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
    
    var assignee: User? {
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
        imageViewAssigneeAvatar.kf.cancelDownloadTask()
        
        if let link = assignee?.avatarUrl,
            let url = URL(string: link) {
            imageViewAssigneeAvatar.kf.setImage(with: url)
        }
        
        self.labelAssigneeName.text = assignee?.name
    }
}
