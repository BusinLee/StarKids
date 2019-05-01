//
//  NewStudentController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/7/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase


let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://starkids1-fda2a.appspot.com")

class NewStudentController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var lbValid: UILabel!
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    
    var arrDate = [[Int]]()
    var date:String = ""
    var day:String = "01"
    var month:String = "01"
    var imgData:Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerBirthDay.delegate = self
        pickerBirthDay.dataSource = self
        imgData = UIImage(named: "camera")!.pngData()
        for i in 0...1 {
            var row = [Int]()
            for j in 0...30 {
                row.append(j+1)
                if (i==1 && j==11) {
                    break
                }
            }
            arrDate.append(row)
        }
        txtBirthYear.text = String(Calendar.current.component(.year, from: Date()) - 5)
        lbValid.isHidden = true
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        // customTitle?.title = "Some Title"
        navigationBar?.title = "Thêm học sinh"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func btnXong(sender: AnyObject) {
        var emailFlag:String = currentUser.email
        self.lbValid.isHidden = true
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn thêm một học sinh mới?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            let alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
            let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            activity.frame = CGRect(x: self.view.frame.size.width/2-20, y: 60, width: 0, height: 0)
            activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            alertActivity.view.addSubview(activity)
            activity.startAnimating()
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.15)
            alertActivity.view.addConstraint(height);
            self.present(alertActivity, animated: true, completion: nil)

            if ((self.month == "04" || self.month == "06" || self.month == "09" || self.month == "11") && self.day == "31") {
                self.lbValid.isHidden = false
                alertActivity.dismiss(animated: true, completion: nil)
            } else {
                if (self.month == "02" && (self.day == "30" || self.day == "31")) {
                    self.lbValid.isHidden = false
                    alertActivity.dismiss(animated: true, completion: nil)
                } else {
                    if (self.month == "02" && self.day == "29" && (Int(self.txtBirthYear.text!)! % 4) != 0) {
                        self.lbValid.isHidden = false
                        alertActivity.dismiss(animated: true, completion: nil)
                    } else {
                        self.date = self.day + self.month + self.txtBirthYear.text!
                        self.lbValid.isHidden = true
                        let email:String = self.txtEmail.text!
                        let password:String = self.date
                        print("Đăng nhập....")
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if (error == nil)
                            {
                                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                                    if (error == nil)
                                    {
                                        print("Đăng nhập thành công")
                                        //alertActivity.dismiss(animated: true, completion: nil)

                                    }
                                }
                                let avatarRef = storageRef.child("avatars/\(email).jpg")
                                let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { metadata, error in
                                    guard let metadata = metadata else {
                                        print("Lỗi up avatar")
                                        alertActivity.dismiss(animated: true, completion: nil)
                                        return
                                    }
                                    let size = metadata.size
                                    avatarRef.downloadURL { (url, error) in

                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = self.txtFullName.text!
                                        changeRequest?.photoURL = url
                                        changeRequest?.commitChanges { (error) in
                                            if (error == nil){
                                                //Set rtdb for user
                                                let tableName = ref.child("ListFriend")
                                                let userId = tableName.child(currentUser.id)
                                                let user:Dictionary<String,String> = ["email":currentUser.email,"fullName":self.txtFullName.text!,"linkAvatar":url!.absoluteString]
                                                userId.setValue(user)
                                                
                                                //Logout
                                                let firebaseAuth = Auth.auth()
                                                do {
                                                    try firebaseAuth.signOut()
                                                } catch let signOutError as NSError {
                                                    print ("Error signing out: %@", signOutError)
                                                }
                                                //Login
                                                Auth.auth().signIn(withEmail: emailFlag, password: defaultUser.value(forKey: "password") as! String) { [weak self] user, error in
                                                    guard let strongSelf = self else { return }
                                                    print("---------Email \(emailFlag)")
                                                    print("---------Email \(defaultUser.value(forKey: "password"))")
                                                    if (error == nil)
                                                    {
                                                        //Get current
                                                        Auth.auth().addStateDidChangeListener { (auth, user) in
                                                            if (user != nil)
                                                            {
                                                                let user = Auth.auth().currentUser
                                                                if let user = user {
                                                                    let uid = user.uid
                                                                    let email = user.email
                                                                    let photoURL = user.photoURL
                                                                    let name = user.displayName
                                                                    
                                                                    currentUser = User(id: uid, email: email ?? "example@gmail.com", fullName: name ?? "example name", linkAvatar: photoURL?.absoluteString ?? "dfsfs")
                                                                    let url:URL = URL(string: currentUser.linkAvatar)!
                                                                    do
                                                                    {
                                                                        let data:Data = try Data(contentsOf: url)
                                                                        currentUser.avatar = UIImage(data: data)
                                                                        self!.gotoScreen(idScreen: "mainTabBarController")
                                                                    }
                                                                    catch
                                                                    {
                                                                        print("lỗi gán avatar current user")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    else
                                                    {
                                                        print("Không đăng nhập được")
                                                    }
                                                }
                                                activity.stopAnimating()
                                                alertActivity.dismiss(animated: true, completion: nil)
                                                //////////
                                                let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Tạo thành công", preferredStyle: .alert)
                                                let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                                                alert1.addAction(btnOk1)
                                                self.present(alert1, animated: true, completion: nil)
                                            } else {
                                                print("Lỗi update profile")
                                                alertActivity.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                }
                                uploadTask.resume()
                            }
                            else
                            {
                                print("Lỗi đăng ký!")
                                alertActivity.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
          }
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tap_Avata(_ sender: UITapGestureRecognizer) {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrDate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDate[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrDate[component][row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0) {
            if (arrDate[component][row] < 10) {
                day = "0" + String(arrDate[component][row])
            } else {
                day = String(arrDate[component][row])
            }
        }
        else {
            if (arrDate[component][row] < 10) {
                month = "0" + String(arrDate[component][row])
            } else {
                month = String(arrDate[component][row])
            }
        }
    }
}
extension NewStudentController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
            self.imgAvatar.image = UIImage(data:imgData)
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
                self.imgAvatar.image = UIImage(data:imgData)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
