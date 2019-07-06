//
//  AddMenuViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/24/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var trackDayMenu:String!
var monMenu:Menu!
var tueMenu:Menu!
var wedMenu:Menu!
var thuMenu:Menu!
var friMenu:Menu!
class AddMenuViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMonMain1: UITextField!
    @IBOutlet weak var lblMonMain2: UITextField!
    @IBOutlet weak var lblMonFry: UITextField!
    @IBOutlet weak var lblMonSoup: UITextField!
    @IBOutlet weak var lblTueMain1: UITextField!
    @IBOutlet weak var lblTueMain2: UITextField!
    @IBOutlet weak var lblTueFry: UITextField!
    @IBOutlet weak var lblTueSoup: UITextField!
    @IBOutlet weak var lblWedMain1: UITextField!
    @IBOutlet weak var lblWedMain2: UITextField!
    @IBOutlet weak var lblWedFry: UITextField!
    @IBOutlet weak var lblWedSoup: UITextField!
    @IBOutlet weak var lblThuMain1: UITextField!
    @IBOutlet weak var lblThuMain2: UITextField!
    @IBOutlet weak var lblThuFry: UITextField!
    @IBOutlet weak var lblThuSoup: UITextField!
    @IBOutlet weak var lblFriMain1: UITextField!
    @IBOutlet weak var lblFriMain2: UITextField!
    @IBOutlet weak var lblFriFry: UITextField!
    @IBOutlet weak var lblFriSoup: UITextField!
    
    @IBOutlet weak var imgMonMain1: UIImageView!
    @IBOutlet weak var imgMonMain2: UIImageView!
    @IBOutlet weak var imgMonFry: UIImageView!
    @IBOutlet weak var imgMonSoup: UIImageView!
    @IBOutlet weak var imgTueMain1: UIImageView!
    @IBOutlet weak var imgTueMain2: UIImageView!
    @IBOutlet weak var imgTueFry: UIImageView!
    @IBOutlet weak var imgTueSoup: UIImageView!
    @IBOutlet weak var imgWedMain1: UIImageView!
    @IBOutlet weak var imgWedMain2: UIImageView!
    @IBOutlet weak var imgWedFry: UIImageView!
    @IBOutlet weak var imgWedSoup: UIImageView!
    @IBOutlet weak var imgThuMain1: UIImageView!
    @IBOutlet weak var imgThuMain2: UIImageView!
    @IBOutlet weak var imgThuFry: UIImageView!
    @IBOutlet weak var imgThuSoup: UIImageView!
    @IBOutlet weak var imgFriMain1: UIImageView!
    @IBOutlet weak var imgFriMain2: UIImageView!
    @IBOutlet weak var imgFriFry: UIImageView!
    @IBOutlet weak var imgFriSoup: UIImageView!
    
    let df = DateFormatter()
    var monday:Date = Date()
    var friday:Date = Date()
    var imgData:Data!
    var currentImageView: UIImageView? = nil
    var activeTextField:UITextField!
    var rightButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        df.dateFormat = "dd/MM/yyyy"
        
        let now = Date()
        
        monday = getMonday(myDate: now)
        friday = Calendar.current.date(byAdding: .day, value: 4, to: monday)!
        lblTitle.text = "Thực đơn " + df.string(from: monday) + "-" + df.string(from: friday)
        lblMonMain1.delegate = self
        lblMonMain2.delegate = self
        lblMonFry.delegate = self
        lblMonSoup.delegate = self
        lblTueMain1.delegate = self
        lblTueMain2.delegate = self
        lblTueFry.delegate = self
        lblTueSoup.delegate = self
        lblWedMain1.delegate = self
        lblWedMain2.delegate = self
        lblWedFry.delegate = self
        lblWedSoup.delegate = self
        lblThuMain1.delegate = self
        lblThuMain2.delegate = self
        lblThuFry.delegate = self
        lblThuSoup.delegate = self
        lblFriMain1.delegate = self
        lblFriMain2.delegate = self
        lblFriFry.delegate = self
        lblFriSoup.delegate = self
        
//        if (trackDayMenu != "none")
//        {
//            getExistMenu(day: trackDayMenu)
//        }
        
        if (monMenu.id != "")
        {
            getExistMenu(day: "monday")
        }
        if (tueMenu.id != "")
        {
            getExistMenu(day: "tuesday")
        }
        if (wedMenu.id != "")
        {
            getExistMenu(day: "wednesday")
        }
        if (thuMenu.id != "")
        {
            getExistMenu(day: "thusday")
        }
        if (friMenu.id != "")
        {
            getExistMenu(day: "friday")
        }
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Thực đơn"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        rightButton = (navigationBar?.rightBarButtonItem)!
        self.navigationItem.rightBarButtonItem = rightButton;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY =  self.view.frame.size.height - keyboardSize.height
        let editTextY:CGFloat! = (self.activeTextField?.frame.origin.y)! - 1000
        if editTextY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editTextY! - (keyboardY - 40)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @IBAction func btn_Mon(_ sender: Any) {
        trackDayMenu = "monday"
        self.gotoScreenWithBack(idScreen: "scrMenuList")
    }
    
    @IBAction func btn_Tue(_ sender: Any) {
        trackDayMenu = "tuesday"
        self.gotoScreenWithBack(idScreen: "scrMenuList")
    }
    
    @IBAction func btn_Wed(_ sender: Any) {
        trackDayMenu = "wednesday"
        self.gotoScreenWithBack(idScreen: "scrMenuList")
    }
    
    @IBAction func btn_Thu(_ sender: Any) {
        trackDayMenu = "thusday"
        self.gotoScreenWithBack(idScreen: "scrMenuList")
    }
    
    @IBAction func btn_Fri(_ sender: Any) {
        trackDayMenu = "friday"
        self.gotoScreenWithBack(idScreen: "scrMenuList")
    }
    
    @objc func btnXong(sender: AnyObject) {
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: view.frame.size.width/2-20, y: 60, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.15)
        alertActivity.view.addConstraint(height);
        self.present(alertActivity, animated: true, completion: nil)
        
        /////////////////////////
        var arrImage:Array<Data> = Array<Data>()
        
        arrImage.append(imgMonMain1.image!.pngData()!)
        arrImage.append(imgMonMain2.image!.pngData()!)
        arrImage.append(imgMonFry.image!.pngData()!)
        arrImage.append(imgMonSoup.image!.pngData()!)
        arrImage.append(imgTueMain1.image!.pngData()!)
        arrImage.append(imgTueMain2.image!.pngData()!)
        arrImage.append(imgTueFry.image!.pngData()!)
        arrImage.append(imgTueSoup.image!.pngData()!)
        arrImage.append(imgWedMain1.image!.pngData()!)
        arrImage.append(imgWedMain2.image!.pngData()!)
        arrImage.append(imgWedFry.image!.pngData()!)
        arrImage.append(imgWedSoup.image!.pngData()!)
        arrImage.append(imgThuMain1.image!.pngData()!)
        arrImage.append(imgThuMain2.image!.pngData()!)
        arrImage.append(imgThuFry.image!.pngData()!)
        arrImage.append(imgThuSoup.image!.pngData()!)
        arrImage.append(imgFriMain1.image!.pngData()!)
        arrImage.append(imgFriMain2.image!.pngData()!)
        arrImage.append(imgFriFry.image!.pngData()!)
        arrImage.append(imgFriSoup.image!.pngData()!)
        
        var arrImageName:Array<String> = Array<String> ()
        
        arrImageName.append("imgMonMain1.jpg")
        arrImageName.append("imgMonMain2.jpg")
        arrImageName.append("imgMonFry.jpg")
        arrImageName.append("imgMonSoup.jpg")
        arrImageName.append("imgTueMain1.jpg")
        arrImageName.append("imgTueMain2.jpg")
        arrImageName.append("imgTueFry.jpg")
        arrImageName.append("imgTueSoup.jpg")
        arrImageName.append("imgWedMain1.jpg")
        arrImageName.append("imgWedMain2.jpg")
        arrImageName.append("imgWedFry.jpg")
        arrImageName.append("imgWedSoup.jpg")
        arrImageName.append("imgThuMain1.jpg")
        arrImageName.append("imgThuMain2.jpg")
        arrImageName.append("imgThuFry.jpg")
        arrImageName.append("imgThuSoup.jpg")
        arrImageName.append("imgFriMain1.jpg")
        arrImageName.append("imgFriMain2.jpg")
        arrImageName.append("imgFriFry.jpg")
        arrImageName.append("imgFriSoup.jpg")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let day = formatter.string(from: date)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var arrImageURL:Array<String> = Array<String> ()
        var avatarRef = storageRef.child("menus/")
        let temp = df.string(from: monday) + "-" + df.string(from: friday)
        let str = temp.replacingOccurrences(of: "/", with: "_", options: NSString.CompareOptions.literal, range:nil)
        let tableName = ref.child("Menus").child(str)
        for i in 0..<arrImage.count
        {
            let pictureName:String = "\(arrImageName[i]).jpg"
            switch (i / 4) {
            case 0:
                avatarRef = storageRef.child("menus/\(str)/Monday/\(pictureName)")
                break
            case 1:
                avatarRef = storageRef.child("menus/\(str)/Tuesday/\(pictureName)")
                break
            case 2:
                avatarRef = storageRef.child("menus/\(str)/Wednesday/\(pictureName)")
                break
            case 3:
                avatarRef = storageRef.child("menus/\(str)/Thusday/\(pictureName)")
                break
            default:
                avatarRef = storageRef.child("menus/\(str)/Friday/\(pictureName)")
                break
            }
            
            let uploadTask = avatarRef.putData(arrImage[i], metadata: nil) { metadata, error in
                guard metadata != nil else {
                    return
                }
                if (i == 3)
                {
                    let menu:Dictionary<String,String> = ["main1":self.lblMonMain1.text!, "linkMain1" : arrImageName[0],"main2":self.lblMonMain2.text!, "linkMain2" : arrImageName[1], "fry":self.lblMonFry.text!, "linkFry" : arrImageName[2], "soup":self.lblMonSoup.text!, "linkSoup" : arrImageName[3]]
                    tableName.child("Monday").setValue(menu)
                }
                if (i == 7)
                {
                    let menu:Dictionary<String,String> = ["main1":self.lblTueMain1.text!, "linkMain1" : arrImageName[4],"main2":self.lblTueMain2.text!, "linkMain2" : arrImageName[5], "fry":self.lblTueFry.text!, "linkFry" : arrImageName[6], "soup":self.lblTueSoup.text!, "linkSoup" : arrImageName[7]]
                    tableName.child("Tuesday").setValue(menu)
                }
                if (i == 11)
                {
                    let menu:Dictionary<String,String> = ["main1":self.lblWedMain1.text!, "linkMain1" : arrImageName[8],"main2":self.lblWedMain2.text!, "linkMain2" : arrImageName[9], "fry":self.lblWedFry.text!, "linkFry" : arrImageName[10], "soup":self.lblWedSoup.text!, "linkSoup" : arrImageName[11]]
                    tableName.child("Wednesday").setValue(menu)
                }
                if (i == 15)
                {
                    let menu:Dictionary<String,String> = ["main1":self.lblThuMain1.text!, "linkMain1" : arrImageName[12],"main2":self.lblThuMain2.text!, "linkMain2" : arrImageName[13], "fry":self.lblThuFry.text!, "linkFry" : arrImageName[14], "soup":self.lblThuSoup.text!, "linkSoup" : arrImageName[15]]
                    tableName.child("Thusday").setValue(menu)
                }
                if (i == 19)
                {
                    let menu:Dictionary<String,String> = ["main1":self.lblFriMain1.text!, "linkMain1" : arrImageName[16],"main2":self.lblFriMain2.text!, "linkMain2" : arrImageName[17], "fry":self.lblFriFry.text!, "linkFry" : arrImageName[18], "soup":self.lblFriSoup.text!, "linkSoup" : arrImageName[19]]
                    tableName.child("Friday").setValue(menu)
                    
                    let notice:Dictionary<String, Any> = ["userSeen":"", "date":day, "time": "\(hour)"+":"+"\(minute)","idContent": str, "content": "thực đơn"]
                    let tableNameNotice = ref.child("NoticesMore")
                    tableNameNotice.childByAutoId().setValue(notice)
                    
                    alertActivity.dismiss(animated: true, completion: nil)
                    //self.gotoScreen(idScreen: "mainTabBarController")
                    let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Tạo menu thành công", preferredStyle: .alert)
                    let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        self.lblMonMain1.text = ""
                        self.lblMonMain2.text = ""
                        self.lblMonFry.text = ""
                        self.lblMonSoup.text = ""
                        self.lblTueMain1.text = ""
                        self.lblTueMain2.text = ""
                        self.lblTueFry.text = ""
                        self.lblTueSoup.text = ""
                        self.lblWedMain1.text = ""
                        self.lblWedMain2.text = ""
                        self.lblWedFry.text = ""
                        self.lblWedSoup.text = ""
                        self.lblThuMain1.text = ""
                        self.lblThuMain2.text = ""
                        self.lblThuFry.text = ""
                        self.lblThuSoup.text = ""
                        self.lblFriMain1.text = ""
                        self.lblFriMain2.text = ""
                        self.lblFriFry.text = ""
                        self.lblFriSoup.text = ""
                        self.imgMonMain1.image = UIImage(named: "camera")
                        self.imgMonMain2.image = UIImage(named: "camera")
                        self.imgMonFry.image = UIImage(named: "camera")
                        self.imgMonSoup.image = UIImage(named: "camera")
                        self.imgTueMain1.image = UIImage(named: "camera")
                        self.imgTueMain2.image = UIImage(named: "camera")
                        self.imgTueFry.image = UIImage(named: "camera")
                        self.imgTueSoup.image = UIImage(named: "camera")
                        self.imgWedMain1.image = UIImage(named: "camera")
                        self.imgWedMain2.image = UIImage(named: "camera")
                        self.imgWedFry.image = UIImage(named: "camera")
                        self.imgWedSoup.image = UIImage(named: "camera")
                        self.imgThuMain1.image = UIImage(named: "camera")
                        self.imgThuMain2.image = UIImage(named: "camera")
                        self.imgThuFry.image = UIImage(named: "camera")
                        self.imgThuSoup.image = UIImage(named: "camera")
                        self.imgFriMain1.image = UIImage(named: "camera")
                        self.imgFriMain2.image = UIImage(named: "camera")
                        self.imgFriFry.image = UIImage(named: "camera")
                        self.imgFriSoup.image = UIImage(named: "camera")
                    })
                    alert1.addAction(btnOk1)
                    self.present(alert1, animated: true, completion: nil)
                }
            }
            uploadTask.resume()
        }
    }
    
    @IBAction func tap_MonMain1(_ sender: Any) {
        currentImageView = imgMonMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_MonMain2(_ sender: Any) {
        currentImageView = imgMonMain2
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_MonFry(_ sender: Any) {
        currentImageView = imgMonFry
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func tap_MonSoup(_ sender: Any) {
        currentImageView = imgMonSoup
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_TueMain1(_ sender: Any) {
        currentImageView = imgTueMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_TueMain2(_ sender: Any) {
        currentImageView = imgTueMain2
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_TueFry(_ sender: Any) {
        currentImageView = imgTueFry
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_TueSoup(_ sender: Any) {
        currentImageView = imgTueSoup
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_WedMain1(_ sender: Any) {
        currentImageView = imgWedMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_WedMain2(_ sender: Any) {
        currentImageView = imgWedMain2
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_WebFry(_ sender: Any) {
        currentImageView = imgWedFry
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_WedSoup(_ sender: Any) {
        currentImageView = imgWedSoup
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_ThuMain1(_ sender: Any) {
        currentImageView = imgThuMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_ThuMain2(_ sender: Any) {
        currentImageView = imgThuMain2
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_ThuFry(_ sender: Any) {
        currentImageView = imgThuFry
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_ThuSoup(_ sender: Any) {
        currentImageView = imgThuSoup
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_FriMain1(_ sender: Any) {
        currentImageView = imgFriMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_FriMain2(_ sender: Any) {
        currentImageView = imgFriMain2
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_FriFry(_ sender: Any) {
        currentImageView = imgFriFry
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_FriSoup(_ sender: Any) {
        currentImageView = imgFriSoup
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func chooseImg() {
        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: "Chọn", preferredStyle: .alert)
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getMonday(myDate: Date) -> Date {
        let cal = Calendar.current
        //let cal = Calendar.current.date(byAdding: .day, value: 7, to: myDate)
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        let mondayNextWeek = Calendar.current.date(byAdding: .day, value: 7, to: mondayInWeek)
        return mondayNextWeek!
    }
    
    func getExistMenu(day:String)
    {
        //trackDayMenu = "none"
        switch day {
        case "monday":
            lblMonMain1.text = monMenu.main1
            lblMonMain2.text = monMenu.main2
            lblMonFry.text = monMenu.fry
            lblMonSoup.text = monMenu.soup
            setImage(img: imgMonMain1, nameImg: monMenu.imgMain1!, selectMenu: monMenu)
            setImage(img: imgMonMain2, nameImg: monMenu.imgMain2!, selectMenu: monMenu)
            setImage(img: imgMonFry, nameImg: monMenu.imgFry!, selectMenu: monMenu)
            setImage(img: imgMonSoup, nameImg: monMenu.imgSoup!, selectMenu: monMenu)
            break
        case "tuesday":
            lblTueMain1.text = tueMenu.main1
            lblTueMain2.text = tueMenu.main2
            lblTueFry.text = tueMenu.fry
            lblTueSoup.text = tueMenu.soup
            setImage(img: imgTueMain1, nameImg: tueMenu.imgMain1!, selectMenu: tueMenu)
            setImage(img: imgTueMain2, nameImg: tueMenu.imgMain2!, selectMenu: tueMenu)
            setImage(img: imgTueFry, nameImg: tueMenu.imgFry!, selectMenu: tueMenu)
            setImage(img: imgTueSoup, nameImg: tueMenu.imgSoup!, selectMenu: tueMenu)
            break
        case "wednesday":
            lblWedMain1.text = wedMenu.main1
            lblWedMain2.text = wedMenu.main2
            lblWedFry.text = wedMenu.fry
            lblWedSoup.text = wedMenu.soup
            setImage(img: imgWedMain1, nameImg: wedMenu.imgMain1!, selectMenu: wedMenu)
            setImage(img: imgWedMain2, nameImg: wedMenu.imgMain2!, selectMenu: wedMenu)
            setImage(img: imgWedFry, nameImg: wedMenu.imgFry!, selectMenu: wedMenu)
            setImage(img: imgWedSoup, nameImg: wedMenu.imgSoup!, selectMenu: wedMenu)
            break
        case "thusday":
            lblThuMain1.text = thuMenu.main1
            lblThuMain2.text = thuMenu.main2
            lblThuFry.text = thuMenu.fry
            lblThuSoup.text = thuMenu.soup
            setImage(img: imgThuMain1, nameImg: thuMenu.imgMain1!, selectMenu: thuMenu)
            setImage(img: imgThuMain2, nameImg: thuMenu.imgMain2!, selectMenu: thuMenu)
            setImage(img: imgThuFry, nameImg: thuMenu.imgFry!, selectMenu: thuMenu)
            setImage(img: imgThuSoup, nameImg: thuMenu.imgSoup!, selectMenu: thuMenu)
            break
        default:
            lblFriMain1.text =  friMenu.main1
            lblFriMain2.text = friMenu.main2
            lblFriFry.text = friMenu.fry
            lblFriSoup.text = friMenu.soup
            setImage(img: imgFriMain1, nameImg: friMenu.imgMain1!, selectMenu:  friMenu)
            setImage(img: imgFriMain2, nameImg: friMenu.imgMain2!, selectMenu: friMenu)
            setImage(img: imgFriFry, nameImg: friMenu.imgFry!, selectMenu: friMenu)
            setImage(img: imgFriSoup, nameImg: friMenu.imgSoup!, selectMenu: friMenu)
            break
        }
    }
//    func getExistMenu(day:String)
//    {
//        //trackDayMenu = "none"
//        switch day {
//        case "monday":
//            lblMonMain1.text = selectedMenu.main1
//            lblMonMain2.text = selectedMenu.main2
//            lblMonFry.text = selectedMenu.fry
//            lblMonSoup.text = selectedMenu.soup
//            setImage(img: imgMonMain1, nameImg: selectedMenu.imgMain1!)
//            setImage(img: imgMonMain2, nameImg: selectedMenu.imgMain2!)
//            setImage(img: imgMonFry, nameImg: selectedMenu.imgFry!)
//            setImage(img: imgMonSoup, nameImg: selectedMenu.imgSoup!)
//            break
//        case "tuesday":
//            lblTueMain1.text = selectedMenu.main1
//            lblTueMain2.text = selectedMenu.main2
//            lblTueFry.text = selectedMenu.fry
//            lblTueSoup.text = selectedMenu.soup
//            setImage(img: imgTueMain1, nameImg: selectedMenu.imgMain1!)
//            setImage(img: imgTueMain2, nameImg: selectedMenu.imgMain2!)
//            setImage(img: imgTueFry, nameImg: selectedMenu.imgFry!)
//            setImage(img: imgTueSoup, nameImg: selectedMenu.imgSoup!)
//            break
//        case "wednesday":
//            lblWedMain1.text = selectedMenu.main1
//            lblWedMain2.text = selectedMenu.main2
//            lblWedFry.text = selectedMenu.fry
//            lblWedSoup.text = selectedMenu.soup
//            setImage(img: imgWedMain1, nameImg: selectedMenu.imgMain1!)
//            setImage(img: imgWedMain2, nameImg: selectedMenu.imgMain2!)
//            setImage(img: imgWedFry, nameImg: selectedMenu.imgFry!)
//            setImage(img: imgWedSoup, nameImg: selectedMenu.imgSoup!)
//            break
//        case "thusday":
//            lblThuMain1.text = selectedMenu.main1
//            lblThuMain2.text = selectedMenu.main2
//            lblThuFry.text = selectedMenu.fry
//            lblThuSoup.text = selectedMenu.soup
//            setImage(img: imgThuMain1, nameImg: selectedMenu.imgMain1!)
//            setImage(img: imgThuMain2, nameImg: selectedMenu.imgMain2!)
//            setImage(img: imgThuFry, nameImg: selectedMenu.imgFry!)
//            setImage(img: imgThuSoup, nameImg: selectedMenu.imgSoup!)
//            break
//        default:
//            lblFriMain1.text = selectedMenu.main1
//            lblFriMain2.text = selectedMenu.main2
//            lblFriFry.text = selectedMenu.fry
//            lblFriSoup.text = selectedMenu.soup
//            setImage(img: imgFriMain1, nameImg: selectedMenu.imgMain1!)
//            setImage(img: imgFriMain2, nameImg: selectedMenu.imgMain2!)
//            setImage(img: imgFriFry, nameImg: selectedMenu.imgFry!)
//            setImage(img: imgFriSoup, nameImg: selectedMenu.imgSoup!)
//            break
//        }
//    }
    
    func setImage (img:UIImageView, nameImg:String, selectMenu:Menu) {
        let pictureRef = storageRef.child("menus/\(selectMenu.id!)/\(selectMenu.day!)/\(nameImg).jpg")
        pictureRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Không load được hình menu")
            } else {
                img.image = UIImage(data: data!)
            }
        }
    }
}
extension AddMenuViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let imgValue = max(image.size.width, image.size.height)
            if (imgValue > 3000) {
                imgData = image.jpegData(compressionQuality: 0.1)
            } else
                if (imgValue > 2000) {
                    imgData = image.jpegData(compressionQuality: 0.3)
                } else {
                    imgData = image.pngData()
            }
            
            let image = info[UIImagePickerController.InfoKey.originalImage]
            currentImageView?.image = image as! UIImage
            
            //self.imgAvatar.image = UIImage(data:imgData)
        }
        else
            if let image = info[.editedImage] as? UIImage {
                let imgValue = max(image.size.width, image.size.height)
                if (imgValue > 3000) {
                    imgData = image.jpegData(compressionQuality: 0.1)
                } else
                    if (imgValue > 2000) {
                        imgData = image.jpegData(compressionQuality: 0.3)
                    } else {
                        imgData = image.pngData()
                }
                let image = info[UIImagePickerController.InfoKey.originalImage]
                currentImageView?.image = image as! UIImage
                //self.imgAvatar.image = UIImage(data:imgData)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
