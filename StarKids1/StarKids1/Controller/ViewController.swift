//
//  ViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 3/24/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogIn.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }


}

