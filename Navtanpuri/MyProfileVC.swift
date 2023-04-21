//
//  MyProfileVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 25/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, UIPickerViewDelegate {
    var strCheck = ""
    var strImageLoad = ""
    var strBusinessID = ""
    var Business_Logo = ""
    var strBusinessName = ""
    var txtSelectBus = UITextField()
    var toolBar = UIToolbar()
    var arrBusinessPlan = NSMutableArray()
    
    var cameraController = UIImagePickerController()
    
    var btnEdit = UIButton()
    
    @IBOutlet weak var imgEditProfile: UIImageView!
    @IBOutlet weak var imgEditName: UIImageView!
    @IBOutlet weak var imgEditEmail: UIImageView!
    @IBOutlet weak var imgEditMobile: UIImageView!
    @IBOutlet weak var imgProfileBG: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgSelectImage: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Navigation Controller Changes
        self.title = "My Profile"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        //============================================================================//
        //Create Left Menu Button
        let btnleft = UIButton(type: .custom)
        btnleft.setImage(#imageLiteral(resourceName: "reveal-icon"), for: .normal)
        btnleft.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(25))
        btnleft.addTarget(self, action: #selector(self.clkToLeftMenuAction), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: btnleft)
        navigationItem.leftBarButtonItem = backButton
        
        //Create Edit Button
        btnEdit = UIButton(type: .custom)
        btnEdit.setImage(#imageLiteral(resourceName: "edit_profile"), for: .normal)
        btnEdit.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        btnEdit.addTarget(self, action: #selector(self.clkToEditSaveAction), for: .touchUpInside)
        let editButton = UIBarButtonItem(customView: btnEdit)
        navigationItem.rightBarButtonItem = editButton
        
        
        //==============================================================//
        imgEditName.isHidden = true
        imgEditEmail.isHidden = true
        imgEditMobile.isHidden = true
        imgEditProfile.isHidden = true
        imgSelectImage.isHidden = true
        txtName.isUserInteractionEnabled = false
        txtEmail.isUserInteractionEnabled = false
        txtMobile.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.SetLoginProfileData), userInfo: self, repeats: false)
    }
    
    @objc func SetLoginProfileData() {
        //Set Profile Data
        let strName = _userDefault.string(forKey: "user_name")
        txtName.text = strName
        
        let strEmail = _userDefault.string(forKey: "email")
        txtEmail.text = strEmail
        
        let strMobile = _userDefault.string(forKey: "mobile")
        txtMobile.text = strMobile
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("willApear")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    // Mark: - Image Picker Delegate
    func actionsheet() {
        let actionSheetPhoto = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action : UIAlertAction) in
            
            _ = self.startCameraFromViewController(self, withDelegate: self, sourceType: .camera)
        }
        
        let actionPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action : UIAlertAction) in
            
            _ = self.startCameraFromViewController(self, withDelegate: self, sourceType: .photoLibrary)
        }
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheetPhoto.addAction(actionCamera)
        actionSheetPhoto.addAction(actionPhotoLibrary)
        actionSheetPhoto.addAction(actionCancel)
        
        actionSheetPhoto.popoverPresentationController?.sourceView = imgSelectImage
        self.present(actionSheetPhoto, animated: true, completion: nil)
        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, sourceType : UIImagePickerController.SourceType) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) == false {
            return false
        }
        
        cameraController = UIImagePickerController()
        cameraController.sourceType = sourceType
        //cameraController.mediaTypes = [kUTTypeImage as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        //let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        
        //if mediaType == kUTTypeImage ,
        let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage// {
        
        //================Image Crop=====================//
        let cropController:TOCropViewController = TOCropViewController(image: pickedImage!)
        cropController.delegate=self
        self.present(cropController, animated: true, completion: nil)
        //===============================================//
        
        //}
        
    }
    
    // MARK: - Cropper Delegate
    @objc(cropViewController:didCropToImage:withRect:angle:) func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        cropViewController.presentingViewController?.dismiss(animated: true,
                                                             completion: {
                                                                self.strImageLoad = "ImageLoad"
                                                                self.imgProfile.image = image
                                                                print("\(image)")
        })
        
        
    }
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToEditSaveAction(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "edit_profile") {
            imgEditName.isHidden = false
            imgEditEmail.isHidden = false
            imgEditMobile.isHidden = false
            imgEditProfile.isHidden = false
            imgSelectImage.isHidden = false
            txtName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
            txtMobile.isUserInteractionEnabled = true
            
            sender .setImage(#imageLiteral(resourceName: "save"), for: .normal)
        }
        else {
            imgEditName.isHidden = true
            imgEditEmail.isHidden = true
            imgEditMobile.isHidden = true
            imgEditProfile.isHidden = true
            imgSelectImage.isHidden = true
            txtName.isUserInteractionEnabled = false
            txtEmail.isUserInteractionEnabled = false
            txtMobile.isUserInteractionEnabled = false
            
            sender .setImage(#imageLiteral(resourceName: "edit_profile"), for: .normal)
        }
    }
    
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        sideMenuVC.toggleMenu()
    }
    
    
    // MARK: - UIButton Action Method
    @IBAction func btnUploadLogoClk(_ sender: Any) {
        self.actionsheet()
    }
    
    
    // Mark: - Image Blur
    var context = CIContext(options: nil)
    func blurEffect() {
        
        DispatchQueue.global(qos: .background).async {
            let currentFilter = CIFilter(name: "CIGaussianBlur")
            let beginImage = CIImage(image: self.imgProfileBG.image!)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(25, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = self.context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            
            DispatchQueue.main.async {
                print("We finished that.")
                // only back on the main thread, may you access UI:
                self.imgProfileBG.image = processedImage
            }
        }
        
        
        
        
        
    }

    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
