//
//  IssueSummaryTableViewCell.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class IssueSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    
    var issue: Issue? {
        didSet {
            self.bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    func bindData() {
        self.labelTitle.text = issue?.title
        self.labelStatus.text = issue?.status.rawValue
        self.labelDate.text = issue?.createdAt
        let totalComment = issue?.totalComments ?? 0
        if totalComment > 1 {
            self.labelComment.text = "\(totalComment) Comments"
        } else {
            self.labelComment.text = "\(totalComment) Comment"
        }
    }
}
