//
//  ViewDetailMenuController.swift
//  StarKids1
//
//  Created by Chau Nguyen on 6/6/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewDetailMenuController: UIViewController {

    @IBOutlet weak var textThongtin: UITextView!
    @IBOutlet weak var nvgThucDon: UINavigationBar!
    @IBOutlet weak var imgMonChinh1: UIImageView!
    @IBOutlet weak var imgMonChinh2: UIImageView!
    @IBOutlet weak var imgMonXao: UIImageView!
    @IBOutlet weak var imgMonSup: UIImageView!
    var week : [String] = []
    var listURL : [String]! = []
    var imgViews: [UIImageView] = []
    var MainDish1 : String!
    var MainDish2 : String!
    var SauteDish : String!
    var Soup : String!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        nvgThucDon.topItem?.title = day
        imgViews = [imgMonChinh1, imgMonChinh2, imgMonXao, imgMonSup]
        getWeek()
        getDetailMenu()
        
        
    }


    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    func getWeek() {
        let dayofWeek = NSCalendar.current.component(.weekday, from: Date())
        if (dayofWeek == 1 || dayofWeek == 7)
        {
            week.append(formatDate(date: Date.today().previous(.monday)))
            week.append(formatDate(date: Date.today().previous(.tuesday)))
            week.append(formatDate(date: Date.today().previous(.wednesday)))
            week.append(formatDate(date: Date.today().previous(.thursday)))
            week.append(formatDate(date: Date.today().previous(.friday)))
        }
        if (dayofWeek == 2)
        {
            week.append(formatDate(date: Date.today()))
            week.append(formatDate(date: Date.today().next(.tuesday)))
            week.append(formatDate(date: Date.today().next(.wednesday)))
            week.append(formatDate(date: Date.today().next(.thursday)))
            week.append(formatDate(date: Date.today().next(.friday)))
        }
        if (dayofWeek == 3)
        {
            week.append(formatDate(date: Date.today().previous(.monday)))
            week.append(formatDate(date: Date.today()))
            week.append(formatDate(date: Date.today().next(.wednesday)))
            week.append(formatDate(date: Date.today().next(.thursday)))
            week.append(formatDate(date: Date.today().next(.friday)))
        }
        if (dayofWeek == 4)
        {
            week.append(formatDate(date: Date.today().previous(.monday)))
            week.append(formatDate(date: Date.today().previous(.tuesday)))
            week.append(formatDate(date: Date.today()))
            week.append(formatDate(date: Date.today().next(.thursday)))
            week.append(formatDate(date: Date.today().next(.friday)))
        }
        if (dayofWeek == 5)
        {
            week.append(formatDate(date: Date.today().previous(.monday)))
            week.append(formatDate(date: Date.today().previous(.tuesday)))
            week.append(formatDate(date: Date.today().previous(.wednesday)))
            week.append(formatDate(date: Date.today()))
            week.append(formatDate(date: Date.today().next(.friday)))
        }
        if (dayofWeek == 6)
        {
            week.append(formatDate(date: Date.today().previous(.monday)))
            week.append(formatDate(date: Date.today().previous(.tuesday)))
            week.append(formatDate(date: Date.today().previous(.wednesday)))
            week.append(formatDate(date: Date.today().previous(.thursday)))
            week.append(formatDate(date: Date.today()))
        }
        
    }
    func displayImage(url: String, imgView: UIImageView)
    {
        Storage.storage().reference(forURL: url).getData(maxSize: 1048576, completion: { (data, error) in
            
            guard let imageData = data, error == nil else {
                return
            }
            imgView.image = UIImage(data: imageData)
        })
        
    }
    func getDetailMenu() {
        if (day == "Thứ 2")
        {
            ref.child("Menu").queryOrdered(byChild: "Date").queryEqual(toValue: week[0])
                .observe(.childAdded, with: { (snapshot) -> Void in
                let value = snapshot.value as? [String:AnyObject]
                if (value != nil)
                {
                    print(value)
                    self.MainDish1 = (value?["MainDish1"])! as? String
                    self.MainDish2 = (value?["MainDish2"])! as? String
                    self.SauteDish = (value?["SauteDish"])! as? String
                    self.Soup = (value?["Soup"])! as? String
                    self.listURL.append((value?["imgDish1"])! as? String ?? "1")
                    self.listURL.append((value?["imgDish2"])! as? String ?? "1")
                    self.listURL.append((value?["imgSaute"])! as? String ?? "1")
                    self.listURL.append((value?["imgSoup"])! as? String ?? "1")
                    
                    self.textThongtin.text = "Món Chính 1: " + self.MainDish1 + "\nMón Chính 2: " + self.MainDish2 + "\nMón Xào: " + self.SauteDish + "\nMón Canh: " + self.Soup
                    for i in 0..<4
                    {
                        self.displayImage(url: self.listURL[i], imgView: self.imgViews[i])
                    }
                }
                else
                {
                    self.textThongtin.text = "Hiện tại chưa có thông tin Menu này"
                    print("lỗi rồi !!!!")
                }
            })
        }
        if (day == "Thứ 3")
        {
            ref.child("Menu").queryOrdered(byChild: "Date").queryEqual(toValue: week[1])
                .observe(.childAdded, with: { (snapshot) -> Void in
                    let value = snapshot.value as? [String:AnyObject]
                    if (value != nil)
                    {
                        print(value)
                        self.MainDish1 = (value?["MainDish1"])! as? String
                        self.MainDish2 = (value?["MainDish2"])! as? String
                        self.SauteDish = (value?["SauteDish"])! as? String
                        self.Soup = (value?["Soup"])! as? String
                        self.listURL.append((value?["imgDish1"])! as? String ?? "1")
                        self.listURL.append((value?["imgDish2"])! as? String ?? "1")
                        self.listURL.append((value?["imgSaute"])! as? String ?? "1")
                        self.listURL.append((value?["imgSoup"])! as? String ?? "1")
                        
                        self.textThongtin.text = "Món Chính 1: " + self.MainDish1 + "\nMón Chính 2: " + self.MainDish2 + "\nMón Xào: " + self.SauteDish + "\nMón Canh: " + self.Soup
                        for i in 0..<4
                        {
                            self.displayImage(url: self.listURL[i], imgView: self.imgViews[i])
                        }
                      
                    }
                    else
                    {
                        self.textThongtin.text = "Hiện tại chưa có thông tin Menu này"
                        print("lỗi rồi !!!!")
                    }
                })
        }
        if (day == "Thứ 4")
        {
            ref.child("Menu").queryOrdered(byChild: "Date").queryEqual(toValue: week[2])
                .observe(.childAdded, with: { (snapshot) -> Void in
                    let value = snapshot.value as? [String:AnyObject]
                    if (value != nil)
                    {
                        print(value)
                        self.MainDish1 = (value?["MainDish1"])! as? String
                        self.MainDish2 = (value?["MainDish2"])! as? String
                        self.SauteDish = (value?["SauteDish"])! as? String
                        self.Soup = (value?["Soup"])! as? String
                        self.listURL.append((value?["imgDish1"])! as? String ?? "1")
                        self.listURL.append((value?["imgDish2"])! as? String ?? "1")
                        self.listURL.append((value?["imgSaute"])! as? String ?? "1")
                        self.listURL.append((value?["imgSoup"])! as? String ?? "1")
                        
                        self.textThongtin.text = "Món Chính 1: " + self.MainDish1 + "\nMón Chính 2: " + self.MainDish2 + "\nMón Xào: " + self.SauteDish + "\nMón Canh: " + self.Soup
                        for i in 0..<4
                        {
                            self.displayImage(url: self.listURL[i], imgView: self.imgViews[i])
                        }
                    }
                    else
                    {
                        self.textThongtin.text = "Hiện tại chưa có thông tin Menu này"
                        print("lỗi rồi !!!!")
                    }
                })
        }
        if (day == "Thứ 5")
        {
            ref.child("Menu").queryOrdered(byChild: "Date").queryEqual(toValue: week[3])
                .observe(.childAdded, with: { (snapshot) -> Void in
                    let value = snapshot.value as? [String:AnyObject]
                    if (value != nil)
                    {
                        print(value)
                        self.MainDish1 = (value?["MainDish1"])! as? String
                        self.MainDish2 = (value?["MainDish2"])! as? String
                        self.SauteDish = (value?["SauteDish"])! as? String
                        self.Soup = (value?["Soup"])! as? String
                        self.listURL.append((value?["imgDish1"])! as? String ?? "1")
                        self.listURL.append((value?["imgDish2"])! as? String ?? "1")
                        self.listURL.append((value?["imgSaute"])! as? String ?? "1")
                        self.listURL.append((value?["imgSoup"])! as? String ?? "1")
                        
                        self.textThongtin.text = "Món Chính 1: " + self.MainDish1 + "\nMón Chính 2: " + self.MainDish2 + "\nMón Xào: " + self.SauteDish + "\nMón Canh: " + self.Soup
                        for i in 0..<4
                        {
                            self.displayImage(url: self.listURL[i], imgView: self.imgViews[i])
                        }
                    }
                    else
                    {
                        self.textThongtin.text = "Hiện tại chưa có thông tin Menu này"
                        print("lỗi rồi !!!!")
                    }
                })
        }
        else
        {
            ref.child("Menu").queryOrdered(byChild: "Date").queryEqual(toValue: week[4])
                .observe(.childAdded, with: { (snapshot) -> Void in
                    let value = snapshot.value as? [String:AnyObject]
                    if (value != nil)
                    {
                        print(value)
                        self.MainDish1 = (value?["MainDish1"])! as? String
                        self.MainDish2 = (value?["MainDish2"])! as? String
                        self.SauteDish = (value?["SauteDish"])! as? String
                        self.Soup = (value?["Soup"])! as? String
                        self.listURL.append((value?["imgDish1"])! as? String ?? "1")
                        self.listURL.append((value?["imgDish2"])! as? String ?? "1")
                        self.listURL.append((value?["imgSaute"])! as? String ?? "1")
                        self.listURL.append((value?["imgSoup"])! as? String ?? "1")
                        
                        self.textThongtin.text = "Món Chính 1: " + self.MainDish1 + "\nMón Chính 2: " + self.MainDish2 + "\nMón Xào: " + self.SauteDish + "\nMón Canh: " + self.Soup
                        for i in 0..<4
                        {
                            self.displayImage(url: self.listURL[i], imgView: self.imgViews[i])
                        }
                       
                    }
                    else
                    {
                        self.textThongtin.text = "Hiện tại chưa có thông tin Menu này"
                        print("lỗi rồi !!!!")
                    }
                })
            
        }
        
    }
 

}
extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}
