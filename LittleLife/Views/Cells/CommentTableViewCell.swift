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
    
    var comment: Comment? {
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
        
        if let link = comment?.author?.avatarUrl,
            let url = URL(string: link) {
            imageViewAuthorAvatar.kf.setImage(with: url)
        }
        
        labelComment.text = comment?.comment
        labelAuthorName.text = comment?.author?.name
        labelDate.text = comment?.publishedAt
    }

}
