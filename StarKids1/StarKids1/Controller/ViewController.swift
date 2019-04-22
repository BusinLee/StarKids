//
//  ViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 3/24/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        
        btnLogIn.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        isLogin();
    }

    @IBAction func btn_LogIn(_ sender: Any) {
        
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: view.frame.size.width/2-20, y: 25, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(229)/255, blue: CGFloat(139)/255, alpha: 1.0)
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        self.present(alertActivity, animated: true, completion: nil)

        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            if (error == nil)
            {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                self!.gotoScreen(idScreen: "scrListChat")
            }
            else
            {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Thông báo", message: "Email hoặc Password không chính xác", preferredStyle: .alert)
                let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(btnOk)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func isLogin()
    {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil)
            {
                //self.gotoScreen(idScreen: "scrListChat")
                self.gotoScreenWithBack(idScreen: "scrListChat")
            } else {
                print("Chua dang nhap")
            }
        }
    }
}
extension UIViewController
{
    func gotoScreen(idScreen:String)
    {
        let screen = self.storyboard?.instantiateViewController(withIdentifier: idScreen)
        if (screen != nil)
        {
            self.present(screen!, animated: true, completion: nil)
        }
        else
        {
            print("Lỗi chuyển màn hình")
        }
    }
    
    func gotoScreenWithBack(idScreen:String)
    {
        let screen = self.storyboard?.instantiateViewController(withIdentifier: idScreen)
        if (screen != nil)
        {
            self.navigationController?.pushViewController(screen!, animated: true)
        }
        else
        {
            print("Lỗi chuyển màn hình")
        }
    }
}
