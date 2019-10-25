//
//  ViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldAccessToken: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // sample access token
        self.textFieldAccessToken.text = "b6fbc3252b550837634d77dac415cf06f6115143"
        
        buttonGo.layer.borderColor = UIColor(red: 251.0/255.0, green: 175.0/255.0, blue: 65.0/255.0, alpha: 1).cgColor
        buttonGo.layer.borderWidth = 1
        buttonGo.layer.cornerRadius = buttonGo.frame.height / 2
    }
    
    @IBAction func ontouchGo(_ sender: Any) {
        if let mainNav = self.storyboard?.instantiateViewController(identifier: "MainNavigation") ,
            let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.changeRootViewTo(viewController: mainNav)
        }
    }
}

