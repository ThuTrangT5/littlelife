//
//  ViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldAccessToken: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkToGoNextScreen()
    }
    
    @IBAction func ontouchGo(_ sender: Any) {
        // validate
        let token = self.textFieldAccessToken.text ?? ""
        if token.count == 0 {
            self.showErrorMessage(message: "Please input access token to continue.")
            return
        }
        
        self.textFieldAccessToken.resignFirstResponder()
    }
    
    
    // MARK:-
    
    private func setupUI() {
        buttonGo.layer.borderColor = kTintColor.cgColor
        buttonGo.layer.borderWidth = 1
        buttonGo.layer.cornerRadius = buttonGo.frame.height / 2
    }
    
    private func setupBinding() {
        self.bindingBaseRx(withViewModel: viewModel, disposeBag: disposeBag)
        
        self.viewModel.user
            .subscribe(onNext: { [weak self](user) in
                if let _ = user {
                    self?.gotoNextScreen()
                }
            })
            .disposed(by: disposeBag)
        
        self.textFieldAccessToken.rx
            .controlEvent(UIControl.Event.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
                if let text = self?.textFieldAccessToken.text,
                    text.count > 0 {
                    self?.viewModel.accessToken.onNext(text)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkToGoNextScreen() {
        if let accessToken = UserDefaults.standard.value(forKey: kAccessToken) as? String,
            accessToken.count > 0 {
            // this user is already login
            // => jump to List screen
            self.gotoNextScreen()
        }
    }
    
    private func gotoNextScreen() {
        if let mainNav = self.storyboard?.instantiateViewController(identifier: "MainNavigation") ,
            let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.changeRootViewTo(viewController: mainNav)
        }
    }
}

