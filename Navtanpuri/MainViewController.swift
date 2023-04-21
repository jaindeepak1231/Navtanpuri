//
//  MainViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit


class MainViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, ServerCallDelegate {
    
    var Click = ""
    var strUDID = ""
    var strVideoURLstring = ""
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    @IBOutlet var constraint_collection_height: NSLayoutConstraint!
    
    var viewForChangePassword = ViewChangePassword()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app_Delegate.InterNet = "Available"
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Navigation Controller Changes
        self.title = "List of Jobs"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        //Create Left Menu Button
        let btnleft = UIButton(type: .custom)
        btnleft.setImage(#imageLiteral(resourceName: "reveal-icon"), for: .normal)
        btnleft.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(25))
        btnleft.addTarget(self, action: #selector(self.clkToLeftMenuAction), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: btnleft)
        navigationItem.leftBarButtonItem = backButton
        //====================================================================================//
        
        
        self.title = Constants.navigationTitle.navtanpuri
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        
        strUDID = OpenUDID.value()
        print(strUDID);
        
        self.CallApiAppStoreNewUpdate()
        
        
        //strVideoURLstring = "https://youtu.be/Pi9bwo60EY4"
        
        //self.SetTokenForPushNotification()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getVideoURL), userInfo: self, repeats: false)
        
        
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.SetTokenForPushNotification), userInfo: self, repeats: false)
        

        
        
    }
    
    
    
    
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
    // MARK: - Login Api Call Method
    func CallApiAppStoreNewUpdate() {
        var infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary?["CFBundleIdentifier"] as? String
        
        let myUrl = "https://itunes.apple.com/lookup?bundleId=" + appID!
        
        print(myUrl)
        
        ServerCall.sharedInstance.requestWithURL(.GET, urlString: myUrl, delegate: self, name: .serverCallNameGetStoreVersion)
    }
    
    
    @objc func SetTokenForPushNotification() {
        
        if _userDefault.string(forKey: "GCM_TOKEN") != nil {
            // init paramters Dictionary
            let myUrl = kBasePath + kSetNotificationToken
            
            let param = ["op"     : "setToken",
                         "device_id" : strUDID,
                         "token"  : _userDefault.string(forKey: "GCM_TOKEN")!]
            
            print(myUrl, param)
            
            ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameSetToken)
        }
        
        
    }
    
    
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetStoreVersion {
            
            let strRes = TO_INT(dicData["resultCount"])
            if strRes == 1 {
                
                let resData = resposeObject["results"] as? NSArray
                if resData != nil {
                    let arrResultResponse = (resposeObject["results"]! as! NSArray).mutableCopy() as! NSMutableArray
                    print(arrResultResponse)
                    
                    let dictStore = arrResultResponse.object(at: 0) as! NSDictionary
                    
                    let strreleaseNotes = TO_STRING(dictStore["releaseNotes"])
                    let versionInAppStore = TO_STRING(dictStore["version"])
                    var infoDictionary = Bundle.main.infoDictionary
                    let localAppVersion = TO_STRING(infoDictionary?["CFBundleShortVersionString"])
                    
                    if versionInAppStore.compare(localAppVersion, options: .numeric, range: nil, locale: .current) == .orderedDescending {
                        // currentVersion is lower than the version
                        print("Need to Update")
                        
                        //////
                        //self.SetTokenForPushNotification()
                        
                        let alertController = UIAlertController(title: "New Update Available", message: strreleaseNotes, preferredStyle: .alert)
                        
                        // Create the actions
                        let updateAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.destructive) {
                            UIAlertAction in
                            
                            let strURL = "https://itunes.apple.com/us/app/navtanpuri/id1202944736?ls=1&mt=8"
                            UIApplication.shared.openURL(URL(string: strURL)!)
                            
                            NSLog("Update Pressed")
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        // Add the actions
                        alertController.addAction(updateAction)
                        alertController.addAction(cancelAction)
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        //////
                    }
                    else {
                        print("Your Current version is already updated")
                    }
                }
            }
        }
        
        else if name == ServerCallName.serverCallNameSetToken {
            
            let strRes = TO_INT(dicData["resultCount"])
            if strRes == 1 {
            }
        }
    }
    
    
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
    //===============================================================================================//
    //===============================================================================================//
    //===============================================================================================//
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        Click = "First"
        self.navigationItem.hidesBackButton = true;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayFromURL(notification:)), name: Notification.Name("videoplay"), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfChagePasswordNotification(notification:)), name: Notification.Name("ChangePassword"), object: nil)
        
        
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.VedioPlayFromNotification), name: NSNotification.Name(rawValue: "NOTIFICATIONVIDEOPLAY"), object: nil)

    }
    
    
//    func VedioPlayFromNotification() {
//        //==================For Video Play In Post Detail=============================//
//        let videoURL = URL(string: app_Delegate.strVideoLink)!
//        
//        let playerVC = MobilePlayerViewController(contentURL: videoURL as URL)
//        playerVC.title = ""
//        playerVC.activityItems = [videoURL]
//        
//        self.present(playerVC, animated: true) {
//            app_Delegate.OreintPosition = true
//            playerVC.play()
//        }
//    }
    
    
    @objc func methodOfChagePasswordNotification(notification: Notification){
        //Take Action on Notification
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.DisplayChangePasswordview), userInfo: self, repeats: false)
    }

    //===============================Set View For Change Password=============================//
    @objc func DisplayChangePasswordview() {
        
        viewForChangePassword = (Bundle.main.loadNibNamed("ViewChangePassword", owner: self, options: nil)?.first as? ViewChangePassword)!
        
        viewForChangePassword.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenWidth), height: CGFloat(screenHeight))
        
        viewForChangePassword.viewBG.layer.cornerRadius = 8
        viewForChangePassword.viewBG.layer.borderWidth = 4
        viewForChangePassword.viewBG.layer.borderColor = Constant.themeColor().cgColor
        
        viewForChangePassword.btnCancel.backgroundColor = Constant.themeColor()
        viewForChangePassword.btnChange.backgroundColor = Constant.themeColor()
        
        viewForChangePassword.txtOldPass.text = ""
        viewForChangePassword.txtNewPass.text = ""
        viewForChangePassword.txtConfirmPass.text = ""
        
        viewForChangePassword.txtOldPass.delegate = self
        viewForChangePassword.txtNewPass.delegate = self
        viewForChangePassword.txtConfirmPass.delegate = self
        
        viewForChangePassword.btnRemoveView.addTarget(self, action: #selector(self.clkTobtnRemoveView), for: .touchUpInside)
        
        viewForChangePassword.btnCancel.addTarget(self, action: #selector(self.clkTobtnRemoveView), for: .touchUpInside)
        
        viewForChangePassword.btnChange.addTarget(self, action: #selector(self.clkToBtnSubmitAction), for: .touchUpInside)
        
        self.view.addSubview(viewForChangePassword)
        self.view.bringSubviewToFront(viewForChangePassword)
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == viewForChangePassword.txtOldPass {
            textField.resignFirstResponder()
            viewForChangePassword.txtNewPass.becomeFirstResponder()
            return false
        }
        else if textField == viewForChangePassword.txtNewPass {
            textField.resignFirstResponder()
            viewForChangePassword.txtConfirmPass.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Clk to ViewChangePassword Button Action
    @IBAction func clkTobtnRemoveView(_ sender: UIButton) {
        viewForChangePassword.removeFromSuperview()
    }
    
    @IBAction func clkToBtnSubmitAction(_ sender: UIButton) {
        //Validation
        if isValidData() == false {
            return
        }else{
            self.view.endEditing(true)
            //Call Api For Submit
//            strName = viewForSendDetail.txtName.text!
//            strMobile = viewForSendDetail.txtMobile.text!
//            strEmail = viewForSendDetail.txtEmail.text!
//            app_Delegate.startLoadingview("")
//            self.CallApiForSendJap()
        }
    }
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        
        if !(viewForChangePassword.txtOldPass?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message: "Please Enter Your Old Password" )
            return false;
        }
        else if !(viewForChangePassword.txtNewPass?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message: "Please Enter Your New Password" )
            return false;
        }
        else if !(viewForChangePassword.txtNewPass.text! == viewForChangePassword.txtConfirmPass.text!){
            Constant.showAlert(title: "", message: "Please Enter Confirm Post" )
            return false;
        }
        
        return true
    }
    

    
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationItem.hidesBackButton = false;
//    }
    
    @objc func getVideoURL() {
        
        let strings = NSString(format:"op=getLiveLink")
        
        Alamofire.request(Connection.open.videoUrl, method: .post, parameters: [:], encoding: "\(strings)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                do {
                    let json = try JSON(data: response.data!)
                    let status = json["status"].numberValue
                
                if status == 0 {
                    let message = json["message"].stringValue
                    if message == "" {
                        app_Delegate.InterNet = "Not Available"
                        self.showMessage(title : "No Internet Connection", message: "Please check your Internet Connection and try again")
                    }
                    else {
                        app_Delegate.InterNet = "Available"
                        self.showMessage(title : "Error", message: message)
                    }
                } else {
                    app_Delegate.InterNet = "Available"
                    let dic = json["mobile_live_link"].array
                    self.strVideoURLstring = (dic?[0]["mobile_live_link"].string)!
                    print(self.strVideoURLstring)
                    app_Delegate.videoURL = self.strVideoURLstring
                }
                }
                catch {
                    
                }
                
            }
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier.reuseIdentifier, for: indexPath) as! CategoryHomeCell
        
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 2.0
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowRadius = 2
        
        cell.configureCellWithIconTitle(name:Constants.items[indexPath.row], imgName: Constants.items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var strWidth = UIScreen.main.bounds.width/2
//        if UIScreen.main.sizeType == .iPhone6Plus {
//            strWidth = strWidth - 42
//            strWidth = strWidth/2
//        }
//        else {
            strWidth = strWidth - 18
            //strWidth = strWidth/2
        //}
        
        return CGSize(width :strWidth,height: 135)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let strScreenTitle = Constants.items[indexPath.row]
        
        if app_Delegate.InterNet == "Not Available" {
            self.showMessage(title : "No Internet Connection", message: "Please check your Internet Connection and try again")
        }
        else {
            if indexPath.row == 0{
                let objLive = self.storyboard?.instantiateViewController(withIdentifier: "LiveEventVC") as! LiveEventVC
                objLive.strLiveURL = strVideoURLstring
                self.navigationController?.pushViewController(objLive, animated: true)
            }
            else if indexPath.row == 1{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LiveDarshan") as! DarshanViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 2{
                let shreeTartamVC = self.storyboard?.instantiateViewController(withIdentifier: "ShreeTartamSagarVC") as! ShreeTartamSagarVC
                self.navigationController?.pushViewController(shreeTartamVC, animated: true)
            }
            else if indexPath.row == 3 {
                let objGurukolamVC = self.storyboard?.instantiateViewController(withIdentifier: "EGurukulamVC") as! EGurukulamVC
                self.navigationController?.pushViewController(objGurukolamVC, animated: true)
            }
            else if indexPath.row == 4 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsView") as! NewsViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 5 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventsView") as! EventsController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 6 {
                let objPublication = self.storyboard?.instantiateViewController(withIdentifier: "PublicationVC") as! PublicationVC
                self.navigationController?.pushViewController(objPublication, animated: true)
            }
            else if indexPath.row == 7 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MandirDirectory") as! MandirDirectoryController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 8 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SewaView") as! SewaViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 9 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LineageView") as! LineageViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 10 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackView") as! FeedBackController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 11 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "IntrectionView") as! IntrectionController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 12 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "JapView") as! JapViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else if indexPath.row == 13 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DonorListVC") as! DonorListVC
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else {
                let objComingSoon = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                objComingSoon.strTitle = strScreenTitle
                self.navigationController?.pushViewController(objComingSoon, animated: true)
            }
        }

    }

    
    func VideoPlay() {
        //==================For Video Play In Post Detail===========================================//
        
            if let selectedVideoUrl = URL(string: strVideoURLstring) {
                let player = AVPlayer(url: selectedVideoUrl)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
        }
//        //let videoURL = URL(string: strVideoURLstring)!
//        let videoURL = URL(string: "https://player.vimeo.com/external/186497194.hd.mp4?s=5b9ae54ba4cc6e325e7ad880e3cd795a29426d1d")!
//        
//        let playerVC = MobilePlayerViewController(contentURL: videoURL as URL)
//        playerVC.title = ""
//        playerVC.activityItems = [videoURL]
//        
//        self.present(playerVC, animated: true) {
//            playerVC.play()
//        }
    }
    
    
    @objc func videoPlayFromURL(notification: Notification) {
        if Click == "First" {
            if let selectedVideoUrl = URL(string: strVideoURLstring) {
                let player = AVPlayer(url: selectedVideoUrl)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
        }
        }
        
    }
    
    
    
    func showMessage (title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("SIDEMENURELOAD"), object: nil)
        sideMenuVC.toggleMenu()
    }
}








