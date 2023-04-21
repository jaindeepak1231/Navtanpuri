//
//  TalimVideosVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 06/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class TalimVideosVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrVideoSection = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoResultFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoResultFound.isHidden = true
        
        let tlabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = "Taalim Videos"
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.boldSystemFont(ofSize: 17) //UIFont(name: "Helvetica", size: 17.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
        
        self.navigationItem.hidesBackButton = false;
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        //=====================================================================================//
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //Table Cell Register
        tblView.register(UINib(nibName: "GranthTableCell", bundle: nil), forCellReuseIdentifier: "GranthTableCell")
        //=====================================================================================//
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getTalimVideoData), userInfo: self, repeats: false)
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
    @objc func getTalimVideoData() {
        // init paramters Dictionary
        let myUrl = kBasePath + kEgurukolamVideoSection
        
        let param = ["op"     : "listSections"]
        
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
                    
                    arrVideoSection.removeAllObjects()
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrVideoSection = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrVideoSection)
                        
                        if arrVideoSection.count == 0 {
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
        return arrVideoSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GranthTableCell", for: indexPath as IndexPath) as! GranthTableCell
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.viewBg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cell.viewBg.layer.cornerRadius = 8
        cell.viewBg.layer.masksToBounds = false
        cell.viewBg.layer.shadowColor = UIColor.white.cgColor
        cell.viewBg.layer.shadowOpacity = 2.0
        cell.viewBg.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBg.layer.shadowRadius = 2
        
        
        var dict: NSDictionary = [:]
        dict = arrVideoSection.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["sec_name"] as! String
        cell.lblGranthName.text = strUserName
        
        cell.lblGranthName.textColor = UIColor.white
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return UITableViewAutomaticDimension
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: NSDictionary = [:]
        dict = arrVideoSection.object(at:indexPath.row) as! NSDictionary
        
        if _userDefault.bool(forKey: "login_flag") == true {
            let objVideo = self.storyboard?.instantiateViewController(withIdentifier: "TalimVideosListVC") as! TalimVideosListVC
            objVideo.dictDetail = dict
            self.navigationController?.pushViewController(objVideo, animated: true)
        }
        else {
            let objLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            objLogin.dictSecDetail = dict
            objLogin.sreScreenFrom = "TalimVideo"
            self.navigationController?.pushViewController(objLogin, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



