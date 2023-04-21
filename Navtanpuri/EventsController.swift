//
//  EventsController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 02/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var strImages = ""
    var mandirTitle = [String]()
    var date = [String]()
    var time = [String]()
    var mandirDescription = [String]()
    var arrEventImages = NSMutableArray()
    
    @IBOutlet weak var eventsTable : UITableView?
    @IBOutlet weak var displayMsg : UILabel?
    @IBOutlet weak var viewFullView : UIView!
    @IBOutlet weak var viewCloseView : UIView!
    @IBOutlet weak var imgEventImage: UIImageView!
    @IBOutlet weak var scrollVireForZoom: UIScrollView!
    @IBOutlet weak var btnCloseZoomView: UIButton!
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var viewForZoom = ViewFullScreen()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFullView.isHidden = true
        viewCloseView.layer.cornerRadius = 25
        viewFullView.layer.masksToBounds = true
        
        // Navigation Controller Changes
        self.title = "Events"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        //======================================================================================//
        //======================================================================================//
        eventsTable?.register(UINib(nibName: "EventTableCell", bundle: nil), forCellReuseIdentifier: "EventTableCell")
        
        eventsTable?.estimatedRowHeight = 100
        eventsTable?.rowHeight = UITableView.automaticDimension
        //======================================================================================//
        //======================================================================================//
        
        displayMsg?.isHidden = true
        //openService(type: "Recent")
        app_Delegate.startLoadingview("")
        openService(type: "UpComing")
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            app_Delegate.startLoadingview("")
            openService(type: "Past")
//        case 1:
//            openService(type: "Recent")
        case 1:
            app_Delegate.startLoadingview("")
            openService(type: "UpComing")
        default:
            break;
        }
    }
    
    
    //==========================================================================================//
    //# TableViewDatasource Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mandirTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath as IndexPath) as! EventTableCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsCell
        
        cell.configureCellWithMandirDetails(mandir: mandirTitle[indexPath.row], date: "\(date[indexPath.row])-\(time[indexPath.row])", templeTitle: mandirTitle[indexPath.row], details: mandirDescription[indexPath.row], images: arrEventImages[indexPath.row] as! [String])
        
        
        let frameTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        cell.objscrlloView.addGestureRecognizer(frameTapGesture)
        cell.objscrlloView.isUserInteractionEnabled = true
        
        
        
        return cell
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let view = sender.view
        print(sender.view!)
        print("\(String(describing: view?.tag))")
        let tapPoint = sender.location(in: eventsTable)
        let tapPointInView = eventsTable?.convert(tapPoint, to: eventsTable)
        let indexPath = eventsTable?.indexPathForRow(at: tapPointInView!)!
        
        let imagees = arrEventImages[(indexPath?.row)!] as! [String]
        print(imagees)
        
        strImages = imagees[app_Delegate.ImgSelection]
        
        //=======================ViewForZoom==============================================//
        
        // viewForZoom = (Bundle.main.loadNibNamed("ViewFullScreen", owner: self, options: nil)?.first as? ViewFullScreen)!
        
        // viewForZoom.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenWidth), height: CGFloat(screenHeight))
        
        //---------------------------------------------------//
        scrollVireForZoom.minimumZoomScale = 1.0
        scrollVireForZoom.maximumZoomScale = 6.0
        scrollVireForZoom.contentSize = imgEventImage.frame.size
        scrollVireForZoom.zoomScale = 0
        scrollVireForZoom.delegate = self
        //---------------------------------------------------//
        
        if strImages == "" {
            imgEventImage.image = UIImage.init(named: "no-image")
        }
        else {
            imgEventImage.loadImageUsingCacheWithUrlString(urlString: strImages)
        }
        
        btnCloseZoomView.addTarget(self, action: #selector(self.clkToRemoveZoomViewAction), for: .touchUpInside)
        
        
        //self.view.addSubview(viewForZoom)
        viewFullView.isHidden = false
        self.view.bringSubviewToFront(viewFullView)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let imagees = arrEventImages[indexPath.row] as! [String]
        print(imagees)
        
        strImages = imagees[app_Delegate.ImgSelection]
        
        //=======================ViewForZoom==============================================//
        
       // viewForZoom = (Bundle.main.loadNibNamed("ViewFullScreen", owner: self, options: nil)?.first as? ViewFullScreen)!
            
       // viewForZoom.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenWidth), height: CGFloat(screenHeight))
            
        //---------------------------------------------------//
        scrollVireForZoom.minimumZoomScale = 1.0
        scrollVireForZoom.maximumZoomScale = 6.0
        scrollVireForZoom.contentSize = imgEventImage.frame.size
        scrollVireForZoom.delegate = self
        //---------------------------------------------------//
            
        if strImages == "" {
            imgEventImage.image = UIImage.init(named: "no-image")
        }
        else {
            imgEventImage.loadImageUsingCacheWithUrlString(urlString: strImages)
        }
            
        btnCloseZoomView.addTarget(self, action: #selector(self.clkToRemoveZoomViewAction), for: .touchUpInside)
            
            
        //self.view.addSubview(viewForZoom)
        viewFullView.isHidden = false
        self.view.bringSubview(toFront: viewFullView)
    }
    */
    
    
    
    //============================Remove Zoom View==================================//
    @IBAction func clkToRemoveZoomViewAction(_ sender: UIButton) {
        viewFullView.isHidden = true
        //viewForZoom.removeFromSuperview()
    }
    
    
    //====================Image Zoom In Zoom Out===================================//
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgEventImage
    }
    //=======================================================================================//
    //==================================================================================//
    //==================================================================================//
    
    
    func openService(type : String) {

        self.mandirTitle = []
        self.mandirDescription = []
        self.date = []
        self.time = []

        Alamofire.request(Connection.open.events, method: .post, parameters: [:], encoding: "op=sewaEventByDuration&doFor=\(type)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                self.arrEventImages = NSMutableArray()
                do {
                    let json = try JSON(data: response.data!)
                    let status = json["status"].numberValue
                    if status == 1 {
                        self.displayMsg?.isHidden = true
                        for i in 0...json["date"].arrayValue.count{
                            
                            let title = json["date"][i]["E_Title"].stringValue
                            let time = json["date"][i]["E_Time"].stringValue
                            let date = json["date"][i]["E_Date"].stringValue
                            let descriptionTxt = json["date"][i]["E_Desc"].stringValue
                            
                            if !(title == "") {
                                self.mandirTitle.append(title)
                                self.time.append(time)
                                self.date.append(date)
                                self.mandirDescription.append(descriptionTxt)
                                let EventImages = json["date"][i]["event_photo"].arrayObject as! [String]
                                print(EventImages)
                                self.arrEventImages.add(EventImages)
                                print(self.arrEventImages)
                            }
                            
                        }
                        app_Delegate.stopLoadingView()
                        print("Title List : \(self.mandirTitle)")
                        self.eventsTable?.reloadData()
                        
                    }
                    else {
                        app_Delegate.stopLoadingView()
                        self.eventsTable?.reloadData()
                        self.displayMsg?.isHidden = false
                    }
                }
                catch{
                    
                }
            }
        }
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    func alertMessage (message : String, titleMsg : String)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
