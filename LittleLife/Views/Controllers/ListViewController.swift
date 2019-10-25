//
//  ListViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    @IBOutlet weak var segmentedStatus: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ListViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupBinding()
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
                if let model = issue {
                    self?.performSegue(withIdentifier: "segueDetail", sender: model)
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
                self?.viewModel.clearData()
                self?.viewModel.getData()
            })
            .disposed(by: disposeBag)
        
        self.tableView.addSubview(refresh)
        self.tableView.tableFooterView = UIView()
        
        self.viewModel.listIssues
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: IssueSummaryTableViewCell.self)) { (row,model,cell) in
                cell.issue = model
        }
        .disposed(by: disposeBag)
        
        self.tableView.rx
            .modelSelected(Issue.self)
            .subscribe(onNext: { [weak self](model) in
                self?.viewModel.selectedIssue.onNext(model)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func onchangeStatusValue(_ sender: UISegmentedControl) {
        
        let newStatus: IssueStatus = (sender.selectedSegmentIndex == 0)
            ? IssueStatus.open
            : (sender.selectedSegmentIndex == 1 ? IssueStatus.close : IssueStatus.all)
        self.viewModel.selectedStatus.onNext(newStatus)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}