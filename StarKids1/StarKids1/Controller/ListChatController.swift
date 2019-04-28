//
//  ListChatController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/14/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase
//let ref = Database.database().reference()
//var currentUser:User!

class ListChatController: UIViewController {
    
    @IBOutlet weak var tblListChat: UITableView!
    var arrUserChat:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListChat.dataSource = self
        tblListChat.delegate = self
        
        //current user
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
            tableView.deselectRow(at: indexPath, animated: true)
        }
        catch
        {
            print("Lỗi load avatar vistior")
        }
    }
}
