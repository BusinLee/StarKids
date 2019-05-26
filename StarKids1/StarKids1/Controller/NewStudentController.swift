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

class NewStudentController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var pickerClass: UIPickerView!
    @IBOutlet weak var txtFatherName: UITextField!
    @IBOutlet weak var txtFatherPhone: UITextField!
    @IBOutlet weak var txtMotherName: UITextField!
    @IBOutlet weak var txtMotherPhone: UITextField!
    
    var activeTextField:UITextField!
    
    var arrDate = [[Int]]()
    var arrClasses:Array<String> = Array<String>()
    var arrTeacherName:Array<String> = Array<String>()
    var date:String = ""
    var day:String = "01"
    var month:String = "01"
    var imgData:Data!
    var gender:String = "Nam"
    var className:String = "Không có"
    var teacherName:String = "Không có"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFullName.delegate = self
        txtBirthYear.delegate = self
        txtEmail.delegate = self
        txtFatherName.delegate = self
        txtFatherPhone.delegate = self
        txtMotherName.delegate = self
        txtMotherPhone.delegate = self
        
        btnMale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnMale.clipsToBounds = true
        
        btnFemale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnFemale.clipsToBounds = true
        
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
        
        pickerBirthDay.delegate = self
        pickerBirthDay.dataSource = self
        pickerClass.delegate = self
        pickerClass.dataSource = self
        
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
        //-----------lbValid.isHidden = true
        
        let tableName = ref.child("Classes")
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                let className:String = (postDict?["className"])! as! String
                let teacherName:String = (postDict?["teacherName"])! as! String
                self.arrTeacherName.append(teacherName)
                self.arrClasses.append(className)
                self.pickerClass.reloadAllComponents()
            } else {
                print("Không có class")
            }
        })
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Thêm học sinh"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))

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
        let editTextY:CGFloat! = self.activeTextField?.frame.origin.y
        if editTextY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editTextY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func btnXong(sender: AnyObject) {
        var emailFlag:String = currentUser.email
        //--------------self.lbValid.isHidden = true
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
                //----------self.lbValid.isHidden = false
                alertActivity.dismiss(animated: true, completion: nil)
            } else {
                if (self.month == "02" && (self.day == "30" || self.day == "31")) {
                    //------------self.lbValid.isHidden = false
                    alertActivity.dismiss(animated: true, completion: nil)
                } else {
                    if (self.month == "02" && self.day == "29" && (Int(self.txtBirthYear.text!)! % 4) != 0) {
                        //---------self.lbValid.isHidden = false
                        alertActivity.dismiss(animated: true, completion: nil)
                    } else {
                        self.date = self.day + self.month + self.txtBirthYear.text!
                        //-------self.lbValid.isHidden = true
                        let email:String = self.txtEmail.text!
                        let password:String = self.date
                        print("Đăng nhập....")
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if (error == nil)
                            {
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
                                                let tableName = ref.child("Users")
                                                let userId = tableName.child((Auth.auth().currentUser?.uid)!)
                                                print("\(userId)")
                                                let none:String = "không có"
                                                let user:Dictionary<String,Any> = ["email":self.txtEmail.text!,"fullName":self.txtFullName.text!,"linkAvatar":url!.absoluteString,"nickName":none, "className":self.className, "teacherName":self.teacherName, "birthDay":self.day+"/"+self.month+"/"+self.txtBirthYear.text!, "gender":self.gender, "hobby":none, "fatherName":self.txtFatherName.text!, "fatherPhone":self.txtFatherPhone.text!, "motherName":self.txtMotherName.text!, "motherPhone":self.txtMotherPhone.text!, "illness":none,"evaluation":none,"note":none,"ability":none,"weight":20,"height":100,"dayLeave":0]
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
                                                    if (error == nil)
                                                    {
                                                        //Get current
                                                        Auth.auth().addStateDidChangeListener { (auth, user) in
                                                            if (user != nil)
                                                            {
                                                                let user = Auth.auth().currentUser
                                                                if let user = user {
                                                                    let uid = user.uid
                                                                    
                                                                    let tableName = ref.child("Users")
                                                                    tableName.observe(.childAdded, with: { (snapshot) -> Void in
                                                                        let postDict = snapshot.value as? [String:AnyObject]
                                                                        if (postDict != nil)
                                                                        {
                                                                            if (snapshot.key == uid) {
                                                                                let email:String = (postDict?["email"])! as! String
                                                                                let fullName:String = (postDict?["fullName"])! as! String
                                                                                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                                                                                let nickName:String = (postDict?["nickName"])! as! String
                                                                                let className:String = (postDict?["className"])! as! String
                                                                                let teacherName:String = (postDict?["teacherName"])! as! String
                                                                                let birthDay:String = (postDict?["birthDay"])! as! String
                                                                                let gender:String = (postDict?["gender"])! as! String
                                                                                let hobby:String = (postDict?["hobby"])! as! String
                                                                                let fatherName:String = (postDict?["fatherName"])! as! String
                                                                                let fatherPhone:String = (postDict?["fatherPhone"])! as! String
                                                                                let motherName:String = (postDict?["motherName"])! as! String
                                                                                let motherPhone:String = (postDict?["motherPhone"])! as! String
                                                                                let weight:Int = (postDict?["weight"])! as! Int
                                                                                let height:Int = (postDict?["height"])! as! Int
                                                                                let illness:String = (postDict?["illness"])! as! String
                                                                                let dayLeave:Int = (postDict?["dayLeave"])! as! Int
                                                                                let evaluation:String = (postDict?["evaluation"])! as! String
                                                                                let note:String = (postDict?["note"])! as! String
                                                                                let ability:String = (postDict?["ability"])! as! String
                                                                                
                                                                                currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", nickName: nickName ?? "nil", className: className ?? "nil", teacherName: teacherName ?? "nil", birthDay: birthDay ?? "nil", gender: gender ?? "nil", hobby: hobby ?? "nil", fatherName: fatherName ?? "nil", fatherPhone: fatherPhone ?? "nil", motherName: motherName ?? "nil", motherPhone: motherPhone ?? "nil", weight: weight ?? 0, height: height ?? 0, illness: illness ?? "nil", dayLeave: dayLeave ?? 0, evaluation: evaluation ?? "nil", note: note ?? "nil", ability: ability ?? "nil")
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
                                                                                
                                                                                activity.stopAnimating()
                                                                                alertActivity.dismiss(animated: true, completion: nil)
                                                                                //////////
                                                                                let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Tạo thành công", preferredStyle: .alert)
                                                                                let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                                                                    self!.txtFullName.text = ""
                                                                                    self!.txtBirthYear.text = String(Calendar.current.component(.year, from: Date()) - 5)
                                                                                    self!.txtEmail.text = ""
                                                                                    self!.txtFatherName.text = ""
                                                                                    self!.txtFatherPhone.text = ""
                                                                                    self!.txtMotherName.text = ""
                                                                                    self!.txtMotherPhone.text = ""
                                                                                    self!.imgAvatar.image = UIImage(named: "camera")
                                                                                    self!.changeColorOfRadioButton(btnYellow: self!.btnMale, btnWhite: self!.btnFemale)
                                                                                })
                                                                                alert1.addAction(btnOk1)
                                                                                self?.present(alert1, animated: true, completion: nil)
                                                                            }
                                                                        }
                                                                    })
                                                                    ///////
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    else
                                                    {
                                                        print("Không đăng nhập được")
                                                    }
                                                }
                                                /////////
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
    
    @IBAction func btn_Male(_ sender: Any) {
        gender = "Nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func btn_Female(_ sender: Any) {
        gender = "Nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
    }
    
    @IBAction func tap_lblMale(_ sender: Any) {
        gender = "Nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func tap_lblFemale(_ sender: Any) {
        gender = "Nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
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
        if pickerView.tag == 1 {
            return arrDate.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return arrDate[component].count
        } else {
            return arrClasses.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(arrDate[component][row])
        } else {
            return String(arrClasses[row])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
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
        } else {
            className = String(arrClasses[row])
            teacherName = String(arrTeacherName[row])
        }
    }
    
    func changeColorOfRadioButton (btnYellow:UIButton, btnWhite:UIButton) {
        btnYellow.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnYellow.clipsToBounds = true
        btnYellow.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        
        btnWhite.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnWhite.clipsToBounds = true
        btnWhite.backgroundColor = UIColor.white
        btnWhite.layer.borderWidth = 0.5
        btnWhite.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
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
