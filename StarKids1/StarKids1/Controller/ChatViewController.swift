//
//  ChatViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtMess: UITextField!
    
    var tableName:DatabaseReference!
    var arridChat:Array<String> = Array<String>()
    var arrtxtChat:Array<String> = Array<String>()
    var arruserChat:Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblChat.dataSource = self
        tblChat.delegate = self
        
        arridChat.append(currentUser.id)
        arridChat.append(visitor.id)
        arridChat.sort()
        let key:String="\(arridChat[0])\(arridChat[1])"
        tableName = ref.child("Chat").child(key)
        
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String : AnyObject]
            if (postDict != nil)
            {
                if(postDict?["id"] as! String == currentUser.id)
                {
                    self.arruserChat.append(currentUser)
                } else
                {
                    self.arruserChat.append(visitor)
                    print("Visitor \(visitor.avatar)")
                }
                self.arrtxtChat.append(postDict?["message"] as! String)
                self.tblChat.reloadData()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func btn_Send(_ sender: Any) {
        let mess:Dictionary<String,String> = ["id":currentUser.id, "message":txtMess.text!]
        tableName.childByAutoId().setValue(mess)
        txtMess.text = ""
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtxtChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentUser.id == arruserChat[indexPath.row].id)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ScreenChat2TableViewCell
            cell.lblMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.image = currentUser.avatar
            return cell
        } else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ScreenChat1TableViewCell
            cell.lblMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.image = visitor.avatar
            return cell
        }
    }
}
