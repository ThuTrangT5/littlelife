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
        self.bindingBaseRx(withViewModel: viewModel, disposeBag: disposeBag)
        
        self.viewModel.selectedIssue
            .subscribe(onNext: { [weak self](issue) in
                if let _ = issue {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.comments
            .subscribe(onNext: { [weak self](_) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.setupTableView()
    }
    
    @IBAction func ontouchAddComment(_ sender: Any) {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? AddCommentViewController {
            vc.viewModel = self.viewModel
        }
    }
    
}

// MARK: - TableView

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        self.tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self](cell, indexPath) in
                self?.viewModel.checkToLoadMore(atIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.getIssueSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.configureHeaderView(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let hasHeaderSections = [kSectionComments, kSectionAssignees, kSectionLabels]
        
        if hasHeaderSections.contains(section) == true {
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.getRows(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _ = try? self.viewModel.selectedIssue.value() else {
            return tableView.dequeueReusableCell(withIdentifier: "cell")
                ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let identifier = self.getCellIdentifier(forIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionEdit = UIContextualAction(style: .normal,
                                            title: "Edit",
                                            handler: { [weak self](action, view, completionHandler) in
                                                self?.handleEditComment(atIndexPath: indexPath)
                                                completionHandler(true)
        })
        actionEdit.backgroundColor = kTintColor
        let actionDelete = UIContextualAction(style: .normal,
                                              title: "Delete",
                                              handler: { [weak self](action, view, completionHandler) in
                                                self?.handleDeleteComment(atIndexPath: indexPath)
                                                completionHandler(true)
        })
        actionDelete.backgroundColor = UIColor.red
        
        
        let configuration = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        return configuration
    }
    
    func handleEditComment(atIndexPath indexPath: IndexPath) {
        guard let comments = try? self.viewModel.comments.value() else {
            return
        }
        
        let comment = comments[indexPath.row]
        self.viewModel.selectedComment.onNext(comment)
        self.performSegue(withIdentifier: "commentSegue", sender: comment)
    }
    
    func handleDeleteComment(atIndexPath indexPath: IndexPath) {
        guard let comments = try? self.viewModel.comments.value() else {
            return
        }
        
        guard let commentID = comments[indexPath.row].id else {
            return
        }
        
        // show alert to confirm
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { [weak self](_) in
            alert.dismiss(animated: true) {
                self?.viewModel.deleteComment(commentID: commentID)
            }
        }
        let no = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
}
