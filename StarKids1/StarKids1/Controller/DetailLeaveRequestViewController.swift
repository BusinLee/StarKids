//
//  DetailLeaveRequestViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class DetailLeaveRequestViewController: UIViewController {

    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblParent: UILabel!
    @IBOutlet weak var lblStudent: UILabel!
    @IBOutlet weak var lblFromDay: UILabel!
    @IBOutlet weak var lblToDay: UILabel!
    @IBOutlet weak var lblReason: UITextView!
    @IBOutlet weak var lblCurrentDay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblReason.layer.borderWidth = 1
        lblReason.layer.borderColor = UIColor.darkGray.cgColor
        
        lblClassName.text = selectedLeaveRequest.className
        lblParent.text = selectedLeaveRequest.parent
        lblStudent.text = selectedLeaveRequest.fullName
        lblFromDay.text = selectedLeaveRequest.fromDay
        lblToDay.text = selectedLeaveRequest.toDay
        lblReason.text = selectedLeaveRequest.reason
        lblCurrentDay.text = selectedLeaveRequest.currentDay
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = selectedLeaveRequest.fullName
    }
    

}
