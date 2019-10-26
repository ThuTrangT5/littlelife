//
//  BaseViewModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/25/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    var error: BehaviorSubject<Error?> = BehaviorSubject<Error?>(value: nil)
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.setupBinding()
    }
    
    func setupBinding() {
        
    }
}
