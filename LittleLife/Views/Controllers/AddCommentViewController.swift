//
//  AddCommentViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/27/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddCommentViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var viewModel: DetailViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupBinding()
    }
    
    func setupUI() {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = kTintColor.cgColor
        
        buttonSubmit.layer.cornerRadius = buttonSubmit.frame.height / 2
        buttonSubmit.layer.borderWidth = 1
        buttonSubmit.layer.borderColor = kTintColor.cgColor
    }
    
    func setupBinding() {
        
        if let viewModel = viewModel {
            self.bindingBaseRx(withViewModel: viewModel, disposeBag: disposeBag)
        }
        
        self.viewModel?.isUpdated
            .subscribe(onNext: { [weak self](updated) in
                if updated == true {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        self.buttonSubmit.rx
            .tap
            .bind { [weak self]() in
                self?.textView.resignFirstResponder()
                if let text = self?.textView.text, text.count > 0 {
                    self?.viewModel?.addCommentToSelectedIssue(comment: text)
                    
                } else {
                    self?.showErrorMessage(message: "Please input a comment")
                }
                
            }
            .disposed(by: disposeBag)
    }
}
