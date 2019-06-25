//
//  ListMenuViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/25/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var selectedDayMenu:String!
class ListMenuViewController: UIViewController {

    @IBOutlet weak var tblListMenu: UITableView!
    
    var listMenuStr:Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblListMenu.delegate = self
        tblListMenu.dataSource = self
        
        let tableName = ref.child("Menus")
        tableName.observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil) {
                let str = snapshot.key.replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.literal, range:nil)
                self.listMenuStr.append("Thực đơn từ \(str)")
                self.tblListMenu.reloadData()
            }
            else {
                print ("Không có thực đơn")
            }
        }
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Danh sách thực đơn"
    }
}
extension ListMenuViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenuStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        cell.lblDay.text = listMenuStr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDayMenu = listMenuStr[indexPath.row]
        gotoScreenWithBack(idScreen: "scrDayOfWeek")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
