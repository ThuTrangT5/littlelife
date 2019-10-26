//
//  DetailViewController+TableView.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/26/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit


extension DetailViewController{
    
    func getIssueSections() -> Int {
        guard let _ = try? self.viewModel.selectedIssue.value() else {
            return 0
        }
        return 4
    }
    
    func getRows(forSection section: Int) -> Int {
        guard let issue = try? self.viewModel.selectedIssue.value() else {
            return 0
        }
        
        var rows = 0
        switch section {
        case kSectionAuthor:
            rows = 1
            break
            
        case kSectionLabels:
            rows = issue.labels.count
            break
            
        case kSectionAssignees:
            rows = issue.assignees.count
            break
            
        case kSectionComments:
            rows = issue.comments.count
            break
            
        default:
            break
        }
        
        return rows
    }
    
    func getCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        var identifier = "cell"
        
        switch indexPath.section {
        case kSectionAuthor:
            identifier = "issue"
            break
            
        case kSectionLabels:
            identifier = "cellLabel"
            break
            
        case kSectionAssignees:
            identifier = "cellAssignee"
            break
            
        case kSectionComments:
            identifier = "cellComment"
            break
            
        default:
            break
        }
        
        return identifier
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
        if let author = cell as? IssueAuthorTableViewCell,
            let issue = try? self.viewModel.selectedIssue.value(){
            author.issue = issue
            
        } else if let label = cell as? LabelTableViewCell {
            self.configLabelCell(cell: label, atIndex: indexPath.row)
            
        } else if let assignee = cell as? AssigneeTableViewCell {
            self.configAssigneeCell(cell: assignee, atIndex: indexPath.row)
            
        } else if let comment = cell as? CommentTableViewCell {
            self.configCommentCell(cell: comment, atIndex: indexPath.row)
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
    }
    
    fileprivate func configLabelCell(cell: LabelTableViewCell, atIndex index: Int) {
        guard let issue = try? self.viewModel.selectedIssue.value(),
            index >= 0,
            index < issue.labels.count else {
                print("Can not config Label Cell")
                return
        }
        
        cell.item = issue.labels[index]
    }
    
    fileprivate func configAssigneeCell(cell: AssigneeTableViewCell, atIndex index: Int) {
        guard let issue = try? self.viewModel.selectedIssue.value(),
            index >= 0,
            index < issue.assignees.count else {
                print("Can not config Assignee Cell")
                return
        }
        
        cell.item = issue.assignees[index]
    }
    
    fileprivate func configCommentCell(cell: CommentTableViewCell, atIndex index: Int) {
        guard let issue = try? self.viewModel.selectedIssue.value(),
            index >= 0,
            index < issue.comments.count else {
                print("Can not config Comment Cell")
                return
        }
        
        cell.item = issue.comments[index]
    }
    
    func configureHeaderView(forSection section: Int) -> UIView? {
        guard let issue = try? self.viewModel.selectedIssue.value() else {
            return nil
        }
        
        if let view = self.tableView.dequeueReusableCell(withIdentifier: "section") {
            switch section {
            case kSectionLabels:
                
                view.textLabel?.text = "Labels (\(issue.labels.count))"
                break
                
            case kSectionAssignees:
                view.textLabel?.text = "Assignees (\(issue.assignees.count))"
                break
                
            case kSectionComments:
                view.textLabel?.text = "Comments (\(issue.comments.count))"
                break
                
            default:
                return nil
            }
            
            return view
        }
        return nil
    }
}
