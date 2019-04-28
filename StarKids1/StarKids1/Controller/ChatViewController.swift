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
        if (arrtxtChat.count == 0)
        {
            addListChat(user1: currentUser, user2: visitor)
            addListChat(user1: visitor, user2: currentUser)
        }
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
    
    func addListChat(user1:User, user2:User)
    {
        let tableName2 = ref.child("ListChat").child(user1.id).child(user2.id)
        let user:Dictionary<String,String> = ["email":user2.email, "fullName":user2.fullName, "linkAvatar":user2.linkAvatar]
        tableName2.setValue(user)
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
            
            cell.contentView.backgroundColor = UIColor.clear
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 30, y: 6, width: self.view.frame.size.width - 20, height: 48))
            
            let color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            whiteRoundedView.layer.backgroundColor = color.cgColor
            
            
            whiteRoundedView.layer.masksToBounds = true
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
          //  cell.clipsToBounds = true
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
