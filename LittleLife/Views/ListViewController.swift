//
//  ListViewController.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var segmentedStatus: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onchangeStatusValue(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDetail", sender: nil)
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
