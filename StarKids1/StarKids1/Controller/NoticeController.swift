//
//  NoticeController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import UserNotifications

class NoticeController: UIViewController {

//    @IBAction func btnNotice(_ sender: Any) {
//        let content = UNMutableNotificationContent()
//        content.title = "The 5 seconds are up!"
//        content.subtitle = "They are up now!"
//        content.body = "The 5 seconds are really up!"
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
    @IBOutlet weak var tblNotice: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
//
//        })
        tblNotice.dataSource = self
        tblNotice.delegate = self
    }

}
extension NoticeController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NoticeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
