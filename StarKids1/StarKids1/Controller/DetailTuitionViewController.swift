//
//  DetailTuitionViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class DetailTuitionViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStudy: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var lblCamp: UILabel!
    @IBOutlet weak var lblVerhical: UILabel!
    @IBOutlet weak var lblExtra: UILabel!
    @IBOutlet weak var lblSum: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Học phí \(selectedTuition.month!) \(selectedTuition.year!)"
        lblStudy.text = selectedTuition.study
        lblSupport.text = selectedTuition.support
        lblCamp.text = selectedTuition.camp
        lblVerhical.text = selectedTuition.verhical
        lblExtra.text = selectedTuition.extra
        lblSum.text = selectedTuition.sum
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Học phí"
    }
    
}
