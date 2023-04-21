//
//  TalimVideosListVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 28/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class TalimVideosListVC: UIViewController, ServerCallDelegate, UITableViewDelegate, UITableViewDataSource {

    var dictDetail: NSDictionary = [:]
    var arrVideoList = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoResultFound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoResultFound.isHidden = true
        lblNoResultFound.text = "No Result Found!"
        
        let tlabel = UILabel.init(frame: CGRect(x: 50, y: 0, width: 200, height: 40))
        tlabel.text = "Taalim Videos"
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.boldSystemFont(ofSize: 17) //UIFont(name: "Helvetica", size: 17.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.tintColor=UIColor.white
        //let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
        //===============================================================================//
        let backButtonView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50)))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: CGFloat(20), dy: CGFloat(0))
        let imgBack = UIImageView()
        imgBack.image = #imageLiteral(resourceName: "left-arrow_white")
        imgBack.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(22), height: CGFloat(22))
        imgBack.center = CGPoint(x: (backButtonView.frame.midX), y: (backButtonView.frame.midY))
        let frameTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.BackViewTapped))
        backButtonView.addGestureRecognizer(frameTapGesture)
        backButtonView.isUserInteractionEnabled = true
        backButtonView.addSubview(imgBack)
        let backButton = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButton
        
//        let btnListBar = UIBarButtonItem(customView: btnBack)
//        self.navigationItem.leftBarButtonItem = btnListBar
        
        
        
        
        
        
        
        
        //======================================================================================//
        
        
        
        
        print(dictDetail)
        //=====================================================================================//
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //Table Cell Register
        tblView.register(UINib(nibName: "GranthVideoTableCell", bundle: nil), forCellReuseIdentifier: "GranthVideoTableCell")
        //=====================================================================================//
        
        app_Delegate.startLoadingview("")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getTalimVideoList), userInfo: self, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        app_Delegate.OreintPosition = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        app_Delegate.OreintPosition = false
    }
    
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
    // MARK: - Login Api Call Method
    @objc func getTalimVideoList() {
        // init paramters Dictionary
        let myUrl = kBasePath + kEgurukolamVideoList
        
        let param = ["op"     : "listVideos",
                     "sec_id" : TO_INT(dictDetail["id"]).description]
        
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
                    
                    arrVideoList.removeAllObjects()
                    let resData = resposeObject["data"] as? NSArray
                    if resData != nil {
                        arrVideoList = (resposeObject["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        print(arrVideoList)
                        
                        if arrVideoList.count == 0 {
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
        return arrVideoList.count
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
        dict = arrVideoList.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["video_title"] as! String
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
        return 123
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: NSDictionary = [:]
        dict = arrVideoList.object(at:indexPath.row) as! NSDictionary
        
        let strThumbImage = dict["file_path"] as! String
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func BackViewTapped(_ sender: UITapGestureRecognizer) {
    //@IBAction func btnclkToBackAction(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TalimVideosVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}




