//
//  LoginViewModel.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/23/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel {

    var accessToken: BehaviorSubject<String?> = BehaviorSubject<String?>(value: nil)
    
    func getAccess() {
        
    }
}
