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
    
    override func setupBinding() {
        self.selectedIssueNumber
            .subscribe(onNext: { [weak self](issueNumber) in
                if let _ = issueNumber {
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
    
    func addComment(string: String) {
        
    }
    
    
}
