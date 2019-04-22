//
//  ListFriendController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var visitor:User!

class ListFriendController: UIViewController {

    var listFriend:Array<User> = Array<User>()

    @IBOutlet weak var tblListFriend: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblListFriend.dataSource = self
        tblListFriend.delegate = self
        
        let tableName = ref.child("ListFriend")
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if (postDict != nil) {
                print("++++++++ \(postDict)")
                let email:String = (postDict?["email"])! as! String
                let fullName:String = (postDict?["fullName"])! as! String
                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                
                let user:User = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                if (user.id != currentUser.id)
                {
                    self.listFriend.append(user)
                }
                self.tblListFriend.reloadData()
            }
            else {
                print("Không có user")
            }
        })
    }
    
}

extension ListFriendController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScreenListFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenListFriendTableViewCell
        cell.lblName.text = listFriend[indexPath.row].fullName
        cell.imageAvatar.loadAvatar(link: listFriend[indexPath.row].linkAvatar)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        visitor = listFriend[indexPath.row]
        let url:URL = URL(string: visitor.linkAvatar)!
        do
        {
            
            let data:Data = try Data(contentsOf: url)
            visitor.avatar = UIImage(data: data)
            //gotoScreen(idScreen: "scrChatView")
            
           
            gotoScreenWithBack(idScreen: "scrChatView")
            
            //let screen = storyboard?.instantiateViewController(withIdentifier: "scrChatView") as! ChatViewController
            //let screen = ChatViewController()
            //navigationController?.pushViewController(screen, animated: true)
        }
        catch
        {
                print("Lỗi load avatar vistior")
        }
    }
}
