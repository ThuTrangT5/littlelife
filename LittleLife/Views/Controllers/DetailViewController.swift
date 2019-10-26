//
//  DetailViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIssueNumber: NSNumber?
    var viewModel: DetailViewModel = DetailViewModel()
    var disposeBag = DisposeBag()
    
    let kSectionAuthor: Int = 0
    let kSectionLabels: Int = 1
    let kSectionAssignees: Int = 2
    let kSectionComments: Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupBinding()
        self.viewModel.selectedIssueNumber.onNext(self.selectedIssueNumber)
    }
    
    func setupBinding() {
        // binding loading && error
        self.viewModel.isLoading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.viewModel.error
            .subscribe(onNext: { [weak self](error) in
                if let error = error {
                    self?.handleError(error: error)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedIssue
            .subscribe(onNext: { [weak self](issue) in
                if let _ = issue {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        self.setupTableView()
    }
    
    func setupTableView() {
        let refresh = UIRefreshControl()
        refresh.tintColor = kTintColor
        refresh.rx.controlEvent(UIControl.Event.valueChanged)
            .subscribe(onNext: { [weak self]() in
                refresh.endRefreshing()
                self?.viewModel.getData()
            })
            .disposed(by: disposeBag)
        
        self.tableView.addSubview(refresh)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func ontouchAddComment(_ sender: Any) {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = try? self.viewModel.selectedIssue.value() else {
            return 0
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let issue = try? self.viewModel.selectedIssue.value() else {
            return 0
        }
        
        var rows = 0
        switch section {
        case kSectionAuthor:
            rows = 1
            break
            
        case kSectionLabels:
            rows = issue.labels.count
            break
            
        case kSectionAssignees:
            rows = issue.assignees.count
            break
            
        case kSectionComments:
            rows = issue.comments.count
            break
            
        default:
            break
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let issue = try? self.viewModel.selectedIssue.value() else {
            return tableView.dequeueReusableCell(withIdentifier: "cell")
                ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        var identifier = "cell"
        
        switch indexPath.section {
        case kSectionAuthor:
            identifier = "issue"
            break
            
        case kSectionLabels:
            identifier = "cellLabel"
            break
            
        case kSectionAssignees:
            identifier = "cellAssignee"
            break
            
        case kSectionComments:
            identifier = "cellComment"
            break
            
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
    }
    
}
