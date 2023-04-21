//
//  NotificationVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 26/02/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrNotificaton = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoResultFound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoResultFound.isHidden = true
        
        // Navigation Controller Changes
        self.title = "Notifications"
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
        
        //==============================================================//
        //=====================================================================================//
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //Table Cell Register
        tblView.register(UINib(nibName: "NotificationTableCell", bundle: nil), forCellReuseIdentifier: "NotificationTableCell")
        //=====================================================================================//
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getNotificationsList), userInfo: self, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
    // MARK: - Login Api Call Method
    @objc func getNotificationsList() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetNotification
        
        let param = ["op"     : "listNotifications"]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetVideoSection)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetVideoSection {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    arrNotificaton.removeAllObjects()
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrNotificaton = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrNotificaton)
                        
                        if arrNotificaton.count == 0 {
                            tblView.isHidden = true
                            lblNoResultFound.isHidden = false
                        }
                        else {
                            tblView.isHidden = false
                            lblNoResultFound.isHidden = true
                        }
                    }
                    
                    tblView.reloadData()
                    
                    app_Delegate.stopLoadingView()
                    
                }
                else {
                    Constant.showAlert(title: "", message: strMsg)
                    return
                }
            }
            else {
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        app_Delegate.stopLoadingView()
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
    //===============================================================================================//
    //===============================================================================================//
    //===============================================================================================//
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrNotificaton.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath as IndexPath) as! NotificationTableCell
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.viewBG.backgroundColor = UIColor.white
        
        cell.viewBG.layer.cornerRadius = 8
        cell.viewBG.layer.masksToBounds = false
        cell.viewBG.layer.shadowColor = UIColor.white.cgColor
        cell.viewBG.layer.shadowOpacity = 2.0
        cell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBG.layer.shadowRadius = 2
        
        
        var dict: NSDictionary = [:]
        dict = arrNotificaton.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["sendMsg"] as! String
        cell.lblTitle.text = strUserName
        
        var strDate = dict["sendDate"] as! String
        let arrTime = strDate.components(separatedBy: " ")
        strDate = arrTime.first!
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strDate)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        strDate = dateFormatter.string(from: date!)
        
        cell.lblTime.text = strDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: NSDictionary = [:]
        dict = arrNotificaton.object(at:indexPath.row) as! NSDictionary
//        
        let strN_Tyupe = dict["mtype"] as! String
        if strN_Tyupe == "v" {
            
            let strThumbImage = dict["vlink"] as! String
            //==================For Video Play In Post Detail======================================//
            let videoURL = URL(string: strThumbImage)!
            
            let playerVC = MobilePlayerViewController(contentURL: videoURL as URL)
            playerVC.title = ""
            playerVC.activityItems = [videoURL]
            
            self.present(playerVC, animated: true) {
                app_Delegate.OreintPosition = true
                playerVC.play()
            }
        }
        
        
        
//        if _userDefault.bool(forKey: "login_flag") == true {
//            let objVideo = self.storyboard?.instantiateViewController(withIdentifier: "TalimVideosListVC") as! TalimVideosListVC
//            objVideo.dictDetail = dict
//            self.navigationController?.pushViewController(objVideo, animated: true)
//        }
//        else {
//            let objLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            objLogin.dictSecDetail = dict
//            objLogin.sreScreenFrom = "TalimVideo"
//            self.navigationController?.pushViewController(objLogin, animated: true)
//        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToLeftMenuAction(_ sender: UIButton) {
        sideMenuVC.toggleMenu()
    }
    
}




