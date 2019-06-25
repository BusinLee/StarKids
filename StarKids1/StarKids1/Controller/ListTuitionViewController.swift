//
//  ListTuitionViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var selectedTuition:Tuition!
class ListTuitionViewController: UIViewController {

    @IBOutlet weak var tblListTuition: UITableView!
    
    var listTuition:Array<Tuition> = Array<Tuition>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblListTuition.delegate = self
        tblListTuition.dataSource = self

        let tableName = ref.child("Tuitions")
        tableName.observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil) {
                let camp:String = (postDict?["camp"])! as! String
                let date:String = (postDict?["date"])! as! String
                let extra:String = (postDict?["extra"])! as! String
                let month:String = (postDict?["month"])! as! String
                let study:String = (postDict?["study"])! as! String
                let sum:String = (postDict?["sum"])! as! String
                let support:String = (postDict?["support"])! as! String
                let verhical:String = (postDict?["verhical"])! as! String
                let year:String = (postDict?["year"])! as! String
                let tuition:Tuition = Tuition(id: snapshot.key, camp: camp, extra: extra, study: study, support: support, verhical: verhical, year: year, month: month, date: date, sum: sum)
                self.listTuition.append(tuition)
                self.tblListTuition.reloadData()
            }
            else {
                print ("Không có học phí")
            }
        }
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Học phí"
    }
    

}
extension ListTuitionViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTuition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TuitionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TuitionTableViewCell
        cell.lblTitle.text = "Học phí \(listTuition[indexPath.row].month!) \(listTuition[indexPath.row].year!)"
        cell.lblSum.text = listTuition[indexPath.row].sum
        cell.lblDay.text = listTuition[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTuition = listTuition[indexPath.row]
        gotoScreenWithBack(idScreen: "scrDetailTuition")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
