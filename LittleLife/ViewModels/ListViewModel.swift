//
//  ListViewModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class ListViewModel: NSObject {
    
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    var listIssues: BehaviorSubject<[Issue]> = BehaviorSubject<[Issue]>(value: [])
    var selectedIssue: BehaviorSubject<Issue?> = BehaviorSubject<Issue?>(value: nil)
    var selectedStatus: BehaviorSubject<IssueStatus> = BehaviorSubject<IssueStatus>(value: IssueStatus.open)
    var error: BehaviorSubject<Error?> = BehaviorSubject<Error?>(value: nil)
    
    var totalIssues: Int = -1
    var latestCursor: String?
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.setupBinding()
    }
    
    func setupBinding() {
        self.selectedStatus
            .subscribe(onNext: { [weak self](status) in
                self?.clearData()
                self?.getData()
            })
        .disposed(by: disposeBag)
    }
    
    func clearData() {
        self.listIssues.onNext([])
        self.latestCursor = nil
        self.totalIssues = -1
    }
    
    func getData() {
        let currentStatus = (try? self.selectedStatus.value()) ?? IssueStatus.open
        
        self.isLoading.onNext(true)
        APIManager.shared.getIssues(status: currentStatus, after: latestCursor) { [weak self](issues, count, error) in
            self?.isLoading.onNext(false)
            
            if let issues = issues {
                self?.latestCursor = issues.last?.cursor
                self?.totalIssues = count
                
                if var currentIssues = try? self?.listIssues.value() {
                    currentIssues.append(contentsOf: issues)
                    self?.listIssues.onNext(currentIssues)
                }
            } else {
                self?.error.onNext(error)
            }
        }
    }
    
    func checkHasMoreData() -> Bool {

        let currentIssueCount = (try? self.listIssues.value().count) ?? 0
        if totalIssues > 0 && totalIssues > currentIssueCount {
            return true
        }
        
        return false
    }
    
    func selectIssue(issue: Issue) {
        
    }
}
