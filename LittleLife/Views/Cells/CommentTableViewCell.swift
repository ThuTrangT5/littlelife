//
//  CommentTableViewCell.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAuthorAvatar: UIImageView!
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelUpdatedDate: UILabel!
    
    var item: Comment? {
        didSet {
            self.bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        imageViewAuthorAvatar.layer.cornerRadius = imageViewAuthorAvatar.frame.height / 2
        imageViewAuthorAvatar.layer.masksToBounds = true
    }
    
    func bindData() {
        imageViewAuthorAvatar.kf.cancelDownloadTask()
        
        if let link = item?.author?.avatarUrl,
            let url = URL(string: link) {
            imageViewAuthorAvatar.kf.setImage(with: url)
        }
        
        labelComment.text = item?.comment
        labelAuthorName.text = item?.author?.name
        labelDate.text = item?.publishedAt
        
        if let updatedAt = item?.updatedAt, updatedAt.count > 0 {
            labelUpdatedDate.text = "Updated \(updatedAt)"
        } else {
            labelUpdatedDate.text = nil
        }
    }
}
