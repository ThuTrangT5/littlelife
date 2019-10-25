//
//  DetailViewModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailViewModel: NSObject {
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    var selectedIssueID: BehaviorSubject<NSNumber?> = BehaviorSubject<NSNumber?>(value: nil)
    var issue: BehaviorSubject<Issue?> = BehaviorSubject<Issue?>(value: nil)

    func getData() {
        
    }
    
    func addComment(string: String) {
        
    }
    
    
}
