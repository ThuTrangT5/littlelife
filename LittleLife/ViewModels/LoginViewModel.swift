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
    var user: BehaviorSubject<User?> = BehaviorSubject<User?>(value: nil)
    
    override func setupBinding() {
        super.setupBinding()
        
        self.accessToken
            .subscribe(onNext: { [weak self](token) in
                if let accessToken = token,
                    accessToken.count > 0 {
                    self?.doLogin(token: accessToken)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func doLogin(token: String) {
        
        self.isLoading.onNext(true)
        
        APIManager.shared.login(accessTopken: token) { [weak self](user, error) in
            self?.isLoading.onNext(false)
            
            if let error = error {
                self?.error.onNext(error)
            } else if let user = user {
                
                // save user info (token & userID)
                UserDefaults.standard.setValue(token, forKey: kAccessToken)
                UserDefaults.standard.setValue(user.id, forKey: kUserID)
                
                self?.user.onNext(user)
            }
        }
    }
}
