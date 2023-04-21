//
//  DonorListVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 12/04/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class DonorListVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var arrDonorList = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoResultFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoResultFound.isHidden = true
        
        // Navigation Controller Changes
        self.title = "Donor"
        lblNoResultFound.text = "No Result Found!"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        //=====================================================================================//
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //Table Cell Register
        tblView.register(UINib(nibName: "DonorTableCell", bundle: nil), forCellReuseIdentifier: "DonorTableCell")
        //=====================================================================================//
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getDonorList), userInfo: self, repeats: false)
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
    // MARK: - Donor Api Call Method
    @objc func getDonorList() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetDonorList
        
        let param = ["op"     : "donorList"]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetDonorList)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetDonorList {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    arrDonorList.removeAllObjects()
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrDonorList = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrDonorList)
                        
                        if arrDonorList.count == 0 {
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
        return arrDonorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonorTableCell", for: indexPath as IndexPath) as! DonorTableCell
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
//        cell.viewBG.backgroundColor = UIColor.white
//        
//        cell.viewBG.layer.cornerRadius = 8
//        cell.viewBG.layer.masksToBounds = false
//        cell.viewBG.layer.shadowColor = UIColor.white.cgColor
//        cell.viewBG.layer.shadowOpacity = 2.0
//        cell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
//        cell.viewBG.layer.shadowRadius = 2
        
        
        var dict: NSDictionary = [:]
        dict = arrDonorList.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["donorName"] as! String
        cell.lblName.text = strUserName
        
        let strSeva = dict["donorSewa"] as! String
        cell.lblSubSeva.text = strSeva
        
        var strInr = dict["donorAmount"] as! String
//        if strInr.contains(".") {
//            let arrInr = strInr.components(separatedBy: ".")
//            strInr = arrInr.first!
//        }
        cell.lblINR.text = strInr
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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




