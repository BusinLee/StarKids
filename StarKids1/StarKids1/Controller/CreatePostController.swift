//
//  CreatePostController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/9/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class CreatePostController: UIViewController {

    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var collectionPic: UICollectionView!
    @IBOutlet weak var btnPicture: UIImageView!
    var rightButton:UIBarButtonItem!
    var selectedAssets = [PHAsset]()
    var photoArray:Array<UIImage> = Array<UIImage>()
    
    @IBOutlet weak var img0: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img9: UIImageView!
    
    var uiimgView:Array<UIImageView> = Array<UIImageView> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiimgView.append(img0)
        uiimgView.append(img1)
        uiimgView.append(img2)
        uiimgView.append(img3)
        uiimgView.append(img4)
        uiimgView.append(img5)
        uiimgView.append(img6)
        uiimgView.append(img7)
        uiimgView.append(img8)
        uiimgView.append(img9)

        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Tạo bài viết mới"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Đăng", style: .done, target: self, action: #selector(btnDone))
        rightButton = (navigationBar?.rightBarButtonItem)!
        self.navigationItem.rightBarButtonItem = nil;
        
        txtContent.text = "Nội dung bài viết..."
        txtContent.textColor = UIColor.lightGray
        txtContent.delegate = self
//        collectionPic.delegate = self
//        collectionPic.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func tap_Picture(_ sender: Any) {
        let vc = BSImagePickerViewController()
        self.bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
            
        }, deselect: { (asset: PHAsset) -> Void in
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count
            {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
        }, completion: nil)
    }
    @objc func btnDone(sender: AnyObject) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let day = formatter.string(from: date)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let post:Dictionary<String,String> = ["content":txtContent.text!, "date":day,"time":"\(hour):\(minute)", "userPost":currentUser.id]
        
        let tableName = ref.child("Posts")
        let refRandom = tableName.childByAutoId()
        refRandom.setValue(post)
        txtContent.text = "Nội dung bài viết..."
        txtContent.textColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = nil;
        let randomChild = refRandom.key
    }
    
    func convertAssetToImages() -> Void {
        if selectedAssets.count != 0
        {
            for i in 0..<selectedAssets.count
            {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                })
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                print("picture đây \(i)")
                self.photoArray.append(newImage! as UIImage)
                
                self.uiimgView[i].image = newImage
            }
            for i in selectedAssets.count..<10
            {
                self.uiimgView[i].isHidden = true
            }
        }
    }
}
extension CreatePostController:UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            self.navigationItem.rightBarButtonItem = rightButton;
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nội dung bài viết..."
            textView.textColor = UIColor.lightGray
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    ///////////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! PicturePostCollectionViewCell
        print("cell đây \(indexPath.row)")
        cell.imgPicturePost.image = photoArray[indexPath.row]
        return cell
    }
}
