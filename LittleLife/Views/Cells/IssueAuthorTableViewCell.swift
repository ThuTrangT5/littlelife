//
//  IssueAuthorTableViewCell.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import Kingfisher

class IssueAuthorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAuthorAvatar: UIImageView!
    @IBOutlet weak var labelIssueName: UILabel!
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var issue: Issue? {
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
        imageViewAuthorAvatar.kf.cancelDownloadTask()
        
        if let link = issue?.author?.avatarUrl,
            let url = URL(string: link) {
            imageViewAuthorAvatar.kf.setImage(with: url)
        }
        
        labelIssueName.text = issue?.title
        labelAuthorName.text = issue?.author?.name
        labelDate.text = issue?.createdAt
    }
}
