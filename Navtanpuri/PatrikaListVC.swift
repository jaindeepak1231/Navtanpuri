//
//  PatrikaListVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 06/02/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class PatrikaListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ServerCallDelegate {
    
    var currentYear = 0
    var strTitle = ""
    var strHindiPDFPath = ""
    var strGujratiPDFPath = ""
    var arrPatrikaData = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoResultFound: UILabel!
    @IBOutlet var viewYearBG: UIView!
    @IBOutlet var btnPrivious: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var lblYear: UILabel!
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var viewForLanguageOptions = ViewLanguageOptions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Navigation Controller Changes
        self.title = "Krishna Pranami Patrika"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        lblNoResultFound.isHidden = true
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //========View Shadow=============//
        viewYearBG.backgroundColor = UIColor.clear
        
        viewYearBG.layer.masksToBounds = false
        viewYearBG.layer.shadowColor = UIColor.black.cgColor
        viewYearBG.layer.shadowOpacity = 1.0
        viewYearBG.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewYearBG.layer.shadowRadius = 1
        //================================//
        
        //Table Cell Register
        tblView.register(UINib(nibName: "GranthVideoTableCell", bundle: nil), forCellReuseIdentifier: "GranthVideoTableCell")
        
        //================================================//
        let date = Date()
        let calendar = Calendar.current
        currentYear = calendar.component(.year, from: date)
        
        lblYear.text = currentYear.description + "'s Patrika"
        //===============================================//
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getPatrikaList), userInfo: self, repeats: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Krishna Pranami Patrika"
    }
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
    // MARK: - Login Api Call Method
    @objc func getPatrikaList() {
        // init paramters Dictionary
        let myUrl = kBasePath + kGetPatrikaList
        
        let param = ["op"     : "listPatrika",
                     "yr" : currentYear.description]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameGetPatrikaList)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameGetPatrikaList {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    
                    arrPatrikaData.removeAllObjects()
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrPatrikaData = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrPatrikaData)
                        
                        if arrPatrikaData.count == 0 {
                            tblView.isHidden = true
                            lblNoResultFound.isHidden = false
                            lblNoResultFound.text = "There is no any Patrika in " + currentYear.description
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
                    tblView.isHidden = true
                    lblNoResultFound.text = strMsg + " in " + currentYear.description
                    lblNoResultFound.isHidden = false
                    //Constant.showAlert(title: "", message: strMsg)
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
    
    
    //===============================Set View For Send Detail==============================//
    func DisplayViewForSelectLanguage() {
        
        viewForLanguageOptions = (Bundle.main.loadNibNamed("ViewLanguageOptions", owner: self, options: nil)?.first as? ViewLanguageOptions)!
        
        viewForLanguageOptions.frame = CGRect(x: CGFloat(0), y: CGFloat(-64), width: CGFloat(screenWidth), height: CGFloat(screenHeight + 64))
        
        
        viewForLanguageOptions.btnHindi.backgroundColor = self.themeColor()
        viewForLanguageOptions.btnGujrati.backgroundColor = self.themeColor()
        
        viewForLanguageOptions.btnRemoveView.addTarget(self, action: #selector(self.clkTobtnRemoveView), for: .touchUpInside)
        
        viewForLanguageOptions.btnHindi.addTarget(self, action: #selector(self.clkTobtnHindiAction), for: .touchUpInside)
        
        viewForLanguageOptions.btnGujrati.addTarget(self, action: #selector(self.clkTobtnGujratiAction), for: .touchUpInside)
        
        self.view.addSubview(viewForLanguageOptions)
        self.view.bringSubviewToFront(viewForLanguageOptions)
        
        self.animateViewForSelectLanguage()
        
    }
    
    func animateViewForSelectLanguage() {
        //AudioServicesPlaySystemSound(bubbleSound)
        viewForLanguageOptions.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: CGFloat(0.2), initialSpringVelocity: CGFloat(10.0), options: .allowUserInteraction, animations: {
            self.viewForLanguageOptions.transform = .identity
        },
        completion: { finished in
        })
    }

    
    
    
    
    
    // MARK: - Clk to ViewChangePassword Button Action
    @IBAction func clkTobtnRemoveView(_ sender: UIButton) {
        viewForLanguageOptions.removeFromSuperview()
    }
    
    @IBAction func clkTobtnHindiAction(_ sender: UIButton) {
        viewForLanguageOptions.removeFromSuperview()
        
        if !(strHindiPDFPath == "") {
            self.title = ""
            let objShowPdf = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewerVC") as! PDFViewerVC
            objShowPdf.strTitle = strTitle
            objShowPdf.strLink = strHindiPDFPath
            self.navigationController?.pushViewController(objShowPdf, animated: true)
        }
    }
    
    @IBAction func clkTobtnGujratiAction(_ sender: UIButton) {
        viewForLanguageOptions.removeFromSuperview()
        
        if !(strGujratiPDFPath == "") {
            self.title = ""
            let objShowPdf = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewerVC") as! PDFViewerVC
            objShowPdf.strTitle = strTitle
            objShowPdf.strLink = strGujratiPDFPath
            self.navigationController?.pushViewController(objShowPdf, animated: true)
        }
    }
    //===============================================================================================//
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
        return arrPatrikaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GranthVideoTableCell", for: indexPath as IndexPath) as! GranthVideoTableCell
        
        cell.backgroundColor = UIColor.clear
        //cell.viewBG.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.viewBG.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cell.viewBG.layer.cornerRadius = 8
        cell.imgThumb.layer.cornerRadius = 8
        cell.viewBG.layer.masksToBounds = false
        cell.viewBG.layer.shadowColor = UIColor.white.cgColor
        cell.viewBG.layer.shadowOpacity = 2.0
        cell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBG.layer.shadowRadius = 2
        
        
        var dict: NSDictionary = [:]
        dict = arrPatrikaData.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["title"] as! String
        cell.lblTitle.text = strUserName
        
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        let strThumbImage = dict["thumb_file"] as! String
        //check cache for image
        if let cachedImage = imageCache.object(forKey: strThumbImage as AnyObject) as? UIImage {
            cell.imgThumb.image = cachedImage
        }
        
        let url = NSURL(string: strThumbImage)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            // download hit an error so lets return out
            if error != nil {
                print(error ?? "Error")
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    
                    imageCache.setObject(downloadedImage, forKey: strThumbImage as AnyObject)
                    cell.imgThumb.image = downloadedImage
                    
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                }
                
            }
        }).resume()
        
        
        
        // cell.imgThumb.loadImageUsingCacheWithUrlString(urlString: strThumbImage)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return UITableViewAutomaticDimension
        return 125
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: NSDictionary = [:]
        dict = arrPatrikaData.object(at:indexPath.row) as! NSDictionary
        
        strTitle = dict["title"] as! String
        strHindiPDFPath = dict["hindipath"] as! String
        strGujratiPDFPath = dict["gujaratipath"] as! String

        DisplayViewForSelectLanguage()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - UIButton Action Method
    @IBAction func btnPriviousAction(_ sender: UIButton) {
        currentYear = currentYear - 1
        lblYear.text = currentYear.description + "'s Patrika"
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getPatrikaList), userInfo: self, repeats: false)
    }
    
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        currentYear = currentYear + 1
        lblYear.text = currentYear.description + "'s Patrika"
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getPatrikaList), userInfo: self, repeats: false)
    }
    
    
    //==================================Set Color============================================//
    func themeColor()->UIColor{
        return UIColor(red:22/255.0, green:24/255.0, blue:81/255.0, alpha: 1.0)
    }
    //=======================================================================================//
    
    
}


