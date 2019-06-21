//
//  ViewListMenuController.swift
//  StarKids1
//
//  Created by Chau Nguyen on 6/5/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

var day = ""


class ViewListMenuController: UIViewController {
    @IBOutlet weak var nvgTop: UINavigationBar!
    @IBOutlet weak var nvgBottom: UINavigationBar!
    @IBOutlet weak var lblThu2: UILabel!
    @IBOutlet weak var lblThu3: UILabel!
    @IBOutlet weak var lblThu4: UILabel!
    @IBOutlet weak var lblThu5: UILabel!
    @IBOutlet weak var lblThu6: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblThu2.layer.cornerRadius = 20
        lblThu3.layer.cornerRadius = 20
        lblThu4.layer.cornerRadius = 20
        lblThu5.layer.cornerRadius = 20
        lblThu6.layer.cornerRadius = 20
        let tapThu2 = UITapGestureRecognizer(target: self, action: #selector(self.GotoDetailMenu(tapGesture:)))
        lblThu2.isUserInteractionEnabled = true
        lblThu2.tag = 1
        lblThu2.addGestureRecognizer(tapThu2)
        let tapThu3 = UITapGestureRecognizer(target: self, action: #selector(self.GotoDetailMenu(tapGesture:)))
        lblThu3.isUserInteractionEnabled = true
        lblThu3.tag = 2
        lblThu3.addGestureRecognizer(tapThu3)
        let tapThu4 = UITapGestureRecognizer(target: self, action: #selector(self.GotoDetailMenu(tapGesture:)))
        lblThu4.isUserInteractionEnabled = true
        lblThu4.tag = 3
        lblThu4.addGestureRecognizer(tapThu4)
        let tapThu5 = UITapGestureRecognizer(target: self, action: #selector(self.GotoDetailMenu(tapGesture:)))
        lblThu5.isUserInteractionEnabled = true
        lblThu5.tag = 4
        lblThu5.addGestureRecognizer(tapThu5)
        let tapThu6 = UITapGestureRecognizer(target: self, action: #selector(self.GotoDetailMenu(tapGesture:)))
        lblThu6.isUserInteractionEnabled = true
        lblThu6.tag = 5
        lblThu6.addGestureRecognizer(tapThu6)
        
    }
    
    
    @objc func GotoDetailMenu(tapGesture: UITapGestureRecognizer)
    {
        if (tapGesture.view!.tag == 1)
        {
            day = lblThu2.text!
            let screen = self.storyboard?.instantiateViewController(withIdentifier:"scrDetailMenu")
            self.present(screen!, animated: true, completion: nil)
        }
        if (tapGesture.view!.tag == 2)
        {
            day = lblThu3.text!
        }
        if (tapGesture.view!.tag == 3)
        {
            day = lblThu4.text!
        }
        if (tapGesture.view!.tag == 4)
        {
            day = lblThu5.text!
//            let screen = self.storyboard?.instantiateViewController(withIdentifier:"scrAddNewMenu")
//            self.present(screen!, animated: true, completion: nil)
        }
        if (tapGesture.view!.tag == 5)
        {
            day = lblThu6.text!
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//            let screen = self.storyboard?.instantiateViewController(withIdentifier:"scrLogin")
//            self.present(screen!, animated: true, completion: nil)
        }
        let screen = self.storyboard?.instantiateViewController(withIdentifier:"scrDetailMenu")
        self.present(screen!, animated: true, completion: nil)
    }
    

}

