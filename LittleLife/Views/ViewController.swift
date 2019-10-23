//
//  ViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonGo: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func ontouchGo(_ sender: Any) {
        if let mainNav = self.storyboard?.instantiateViewController(identifier: "MainNavigation") {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.rootViewController = mainNav
        }
    }
    
}

