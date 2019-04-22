//
//  ListChatController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/14/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase
let ref = Database.database().reference()
var currentUser:User!

class ListChatController: UIViewController {
    
    @IBOutlet weak var tblListChat: UITableView!
    var arrUserChat:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListChat.dataSource = self
        tblListChat.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            let name = user.displayName
            
            currentUser = User(id: uid, email: email!, fullName: name!, linkAvatar: photoURL!.absoluteString)
            
            let tableName = ref.child("ListFriend")
            let userId = tableName.child(currentUser.id)
            let user:Dictionary<String,String> = ["email":currentUser.email,"fullName":currentUser.fullName,"linkAvatar":currentUser.linkAvatar]
            userId.setValue(user)
            let url:URL = URL(string: currentUser.linkAvatar)!
            do
            {
                let data:Data = try Data(contentsOf: url)
                currentUser.avatar = UIImage(data: data)
            }
            catch
            {
                print("lỗi gán avatar current user")
            }
        }
        let tableName = ref.child("ListChat").child(currentUser.id)
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                let email:String = (postDict?["email"])! as! String
                let fullName:String = (postDict?["fullName"])! as! String
                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                let user:User = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                self.arrUserChat.append(user)
                self.tblListChat.reloadData()
            }
        })
    }
    
    
    @IBAction func btn_Temp(_ sender: Any) {
        self.gotoScreenWithBack(idScreen: "scrListFriend")
    }

}
extension ListChatController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenListChatTableViewCell
        cell.lblName.text = arrUserChat[indexPath.row].fullName
        cell.imgAvatar.loadAvatar(link: arrUserChat[indexPath.row].linkAvatar)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        visitor = arrUserChat[indexPath.row]
        let url:URL = URL(string: visitor.linkAvatar)!
        do
        {
            
            let data:Data = try Data(contentsOf: url)
            visitor.avatar = UIImage(data: data)
            gotoScreenWithBack(idScreen: "scrChatView")
        }
        catch
        {
            print("Lỗi load avatar vistior")
        }
    }
}
