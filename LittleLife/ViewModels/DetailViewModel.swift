//
//  DetailViewModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailViewModel: BaseViewModel {
    
    var selectedIssueNumber: BehaviorSubject<NSNumber?> = BehaviorSubject<NSNumber?>(value: nil)
    var selectedIssue: BehaviorSubject<Issue?> = BehaviorSubject<Issue?>(value: nil)
    var selectedComment: BehaviorSubject<Comment?> = BehaviorSubject<Comment?>(value: nil)
    
    var comments: BehaviorSubject<[Comment]> = BehaviorSubject<[Comment]>(value: [])
    
    var isUpdated: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
    var totalComments: Int = -1
    var latestCursor: String?
    
    override func setupBinding() {
        self.selectedIssueNumber
            .subscribe(onNext: { [weak self](issueNumber) in
                if let _ = issueNumber {
                    self?.getData()
                }
            })
            .disposed(by: disposeBag)
        
        self.isUpdated
            .subscribe(onNext: { [weak self](updated) in
                if updated == true {
                    self?.getData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK:- Read
    
    func getData() {
        guard let number = try? self.selectedIssueNumber.value() else {
            return
        }
        
        self.isLoading.onNext(true)
        
        APIManager.shared.getIssueDetail(issueNumber: number) { [weak self](issue, error) in
            self?.isLoading.onNext(false)
            
            if let error = error {
                self?.error.onNext(error)
                
            } else if let issue = issue {
                self?.selectedIssue.onNext(issue)
                self?.reloadComments()
            } 
        }
    }
    
    func reloadComments() {
        self.latestCursor = nil
        self.totalComments = -1
        self.comments.onNext([])
        
        self.getComments()
    }
    
    func getComments() {
        
        guard let selectedIssue = try? self.selectedIssue.value(),
            let issueNumber = selectedIssue.number else {
                print("Can not detect selected Issue")
                return
        }
        
        self.isLoading.onNext(true)
        
        APIManager.shared.getComments(issueNumber: issueNumber, after: self.latestCursor) { [weak self](comments, count, endCursor, error) in
            
            self?.isLoading.onNext(false)
            
            if let comments = comments {
                self?.latestCursor = endCursor
                self?.totalComments = count
                
                if var currentComments = try? self?.comments.value() {
                    currentComments.append(contentsOf: comments)
                    self?.comments.onNext(currentComments)
                }
            } else {
                self?.error.onNext(error)
            }
        }
    }
    
    func checkToLoadMore(atIndex index: Int) {
        
        guard let isLoading = try? self.isLoading.value(),
            isLoading == false else {
            return
        }
        
        let currentCommentCount = (try? self.comments.value().count) ?? 0
        
        if index == currentCommentCount - 1
            && totalComments > currentCommentCount{
            
            print("==> get more comments at index \(index)")
            self.getComments()
        }
    }
    
    // MARK:- Add, Edit, Delete
    func addCommentToSelectedIssue(comment: String) {
        guard comment.count > 0 else {
            print("Comment text can not be empty")
            return
        }
        
        guard let selectedIssue = try? self.selectedIssue.value(),
            let issueID = selectedIssue.id else {
                print("Can not detect selected Issue")
                return
        }
        
        self.isLoading.onNext(true)
        APIManager.shared.addCommentForIssue(comment: comment, issueID: issueID) { [weak self](commentID, error) in
            self?.isLoading.onNext(false)
            
            if let error = error {
                self?.error.onNext(error)
            } else if let _ = commentID {
                self?.isUpdated.onNext(true)
            }
        }
    }
    
    func deleteComment(commentID: String) {
        guard commentID.count > 0 else {
            return
        }
        
        self.isLoading.onNext(true)
        APIManager.shared.deleteComment(commentID: commentID) { [weak self](success, error) in
            self?.isLoading.onNext(false)
            
            if let error = error {
                self?.error.onNext(error)
            } else {
                self?.isUpdated.onNext(success)
            }
        }
    }
    
    func editComment(commentID: String, newComment: String) {
        guard newComment.count > 0, commentID.count > 0 else {
            print("Comment text can not be empty")
            return
        }
        
        self.isLoading.onNext(true)
        APIManager.shared.editCommentForIssue(comment: newComment, commentID: commentID, callback: { [weak self](success, error) in
            self?.isLoading.onNext(false)
            
            if let error = error {
                self?.error.onNext(error)
            } else {
                self?.isUpdated.onNext(success)
            }
        })
    }
    
}
