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
    
    var isUpdated: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
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
            } 
        }
    }
    
    func addComment(text: String, issueID: String) {
        guard text.count > 0, issueID.count > 0 else {
            return
        }
        
        self.isLoading.onNext(true)
        APIManager.shared.addCommentForIssue(comment: text, issueID: issueID) { [weak self](commentID, error) in
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
    
}
