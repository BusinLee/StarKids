//
//  ViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 3/24/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

let defaultUser = UserDefaults.standard
class ViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Log out
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
        
        //isLogin();
    }

    @IBAction func btn_LogIn(_ sender: Any) {
        
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: view.frame.size.width/2-20, y: 60, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.15)
        alertActivity.view.addConstraint(height);
        self.present(alertActivity, animated: true, completion: nil)

        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            if (error == nil)
            {
                defaultUser.set(self!.txtPassword.text!, forKey: "password")
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                self!.gotoScreen(idScreen: "scrLoading")
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
                self.gotoScreen(idScreen: "mainTabBarController")
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
