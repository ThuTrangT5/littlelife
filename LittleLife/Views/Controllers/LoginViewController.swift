//
//  ViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldAccessToken: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
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
        
        //  login
        self.login()
    }
    
    
    // MARK:-
    
    private func setupUI() {
        buttonGo.layer.borderColor = UIColor(red: 251.0/255.0, green: 175.0/255.0, blue: 65.0/255.0, alpha: 1).cgColor
        buttonGo.layer.borderWidth = 1
        buttonGo.layer.cornerRadius = buttonGo.frame.height / 2
    }
    
    private func login() {
        if let token = self.textFieldAccessToken.text,
            token.count > 0 {
            APIManager.shared.login(accessTopken: token) { [weak self](username, error) in
                if let urs = username {
                    print("Login user = \(urs)")
                    // save access token
                    UserDefaults.standard.setValue(token, forKey: kAccessToken)
                    
                    self?.gotoNextScreen()
                    
                } else if let error = error {
                    self?.handleError(error: error)
                }
            }
        }
    }
    
    private func checkToGoNextScreen() {
        if let accessToken = UserDefaults.standard.value(forKey: kAccessToken) as? String,
            accessToken.count > 0 {
            // this user is already login
            // => keep going to List screen
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

