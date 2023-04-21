//
//  MandirDirectoryController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 27/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MandirDirectoryController: UIViewController,UITableViewDataSource,UITableViewDelegate,DataSentDelegate,DataSentDelegateFor5s{
    
    @IBOutlet weak var mandirTable : UITableView?
    
    var processView = UIActivityIndicatorView()
    var templeName = [String]()
    var templeAddress = [String]()
    var templePhone = [String]()
    var templeFax = [String]()
    var templeEmail = [String]()
    var templeAccommodation = [String]()
    var templeFood = [String]()
    var contactPerson = [String]()
    var mandirImg = [String]()
    
    var test = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Controller Changes
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        self.title = Constants.navigationTitle.mandirDirectory

        openService()

        processView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        processView.center = view.center
        view.addSubview(processView)
    }
    func userDidEnterData(country: String, state: String, district: String, accommodation: String, food: String) {

        let string = NSString(format:"op=searchMandirByFilter&vCountry=%@&vStates=%@&vCities=%@&vAccommodation=%@&vFood=%@" ,country,state,district,accommodation,food)
        print(string)
        
        
        searchMandirByFilter(string: string)
    }
    func userDidEnterDataFor5s(country: String, state: String, district: String, accommodation: String, food: String) {
        
        let string = NSString(format:"op=searchMandirByFilter&vCountry=%@&vStates=%@&vCities=%@&vAccommodation=%@&vFood=%@" ,country,state,district,accommodation,food)
        print(string)
        
        
        searchMandirByFilter(string: string)
    }
    override func viewWillAppear(_ animated: Bool) {
//        print("call")
//        
//        if test.isEmpty == false {
//            print(test)
//        }
////        let string = NSString(format:"op=searchMandirByFilter&vCountry=%@&vStates=%@&vCities=%@&vAccommodation=%@&vFood=%@" ,vc.country!,vc.state!,vc.district!,vc.accommodation!,vc.food!)
////        print(string)
////        
////        
////        searchMandirByFilter(string: string)
////        }
    }
    func searchMandirByFilter(string : NSString) {
        
        self.mandirImg = []
        self.templeAccommodation = []
        self.contactPerson = []
        self.templeFax = []
        self.templeFood = []
        self.templePhone = []
        self.templeAddress = []
        self.templeName = []
        self.templeEmail = []
        
        processView.startAnimating()
        Alamofire.request(Connection.open.mandirDirectory, method: .post, parameters: [:], encoding: "\(string)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                    //                let status = json["date"]["status"].numberValue
                    //                
                    //                if status == 1 {
                    
                    for i in 0...json["date"].arrayValue.count-1{
                        
                        let Accommodation = json["date"][i]["Accommodation"].stringValue
                        let ContactPerson = json["date"][i]["ContactPerson"].stringValue
                        let Fax = json["date"][i]["Fax"].stringValue
                        let Food = json["date"][i]["Food"].stringValue
                        let Phone = json["date"][i]["Phone"].stringValue
                        let TempleAddress = json["date"][i]["TempleAddress"].stringValue
                        let TempleName = json["date"][i]["TempleName"].stringValue
                        let email = json["date"][i]["TempleName"].stringValue
                        
                        let mandirImgUrl = json["date"][i]["TempleImages"].stringValue
                        
                        self.mandirImg.append(mandirImgUrl)
                        self.templeAccommodation.append(Accommodation)
                        self.contactPerson.append(ContactPerson)
                        self.templeFax.append(Fax)
                        self.templeFood.append(Food)
                        self.templePhone.append(Phone)
                        self.templeAddress.append(TempleAddress)
                        self.templeName.append(TempleName)
                        self.templeEmail.append(email)
                        
                        //                    }
                        print("Null : \(self.isNull(someObject: mandirImgUrl as AnyObject?))")
                        self.mandirTable?.reloadData()
                        self.processView.stopAnimating()
                        
                        
                    }
                }
                catch {
                }
            }
        }
    }
    func openService() {
        
        processView.startAnimating()
        Alamofire.request(Connection.open.mandirDirectory, method: .post, parameters: [:], encoding: Connection.mandir, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                    
                    if  json["date"].arrayValue.count > 1
                    {
                        for i in 0...json["date"].arrayValue.count-1{
                            
                            let Accommodation = json["date"][i]["Accommodation"].stringValue
                            let ContactPerson = json["date"][i]["ContactPerson"].stringValue
                            let Fax = json["date"][i]["Fax"].stringValue
                            let Food = json["date"][i]["Food"].stringValue
                            let Phone = json["date"][i]["Phone"].stringValue
                            let TempleAddress = json["date"][i]["TempleAddress"].stringValue
                            let TempleName = json["date"][i]["TempleName"].stringValue
                            let email = json["date"][i]["TempleName"].stringValue
                            let mandirImgUrl = json["date"][i]["TempleImages"].stringValue
                            
                            self.mandirImg.append(mandirImgUrl)
                            self.templeAccommodation.append(Accommodation)
                            self.contactPerson.append(ContactPerson)
                            self.templeFax.append(Fax)
                            self.templeFood.append(Food)
                            self.templePhone.append(Phone)
                            self.templeAddress.append(TempleAddress)
                            self.templeName.append(TempleName)
                            self.templeEmail.append(email)
                            
                        }
                    }
                    //print(self.templeName)
                    self.mandirTable?.reloadData()
                    self.processView.stopAnimating()
                    
                }
                catch {
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templeName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mandirCell", for: indexPath) as! MandirCell
      
        let url = "\(mandirImg[indexPath.row])" as String?
      //  let url = nullToNil(value: mandirImg[indexPath.row] as AnyObject?) as! String?
        
        
        if url?.isEmpty == false {
            cell.configureCellWithImageWithText(url: mandirImg[indexPath.row])
        }else {
            cell.mandirImg?.image = UIImage(named: "defaultimage")
        }
        
        cell.configureCellWithMandirDetails(mandir: templeName[indexPath.row], phonenumber: templePhone[indexPath.row], faxnumber: templeFax[indexPath.row], emailadd: templeEmail[indexPath.row], contact: contactPerson[indexPath.row], accomodate: templeAccommodation[indexPath.row], foods: templeFood[indexPath.row], address: templeAddress[indexPath.row])
        tableView.rowHeight = 380
        cell.contentView.alpha = 0
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            cell.contentView.alpha = 1.0
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterView" {
            let sendingVC: FilterViewController = segue.destination as! FilterViewController
            sendingVC.delegate = self
        }
    }
    func isNull(someObject: AnyObject?) -> Bool {
        
        guard let someObject = someObject else {
            return true
        }
        return (someObject is NSNull)
    }
    func nullToNil(value : AnyObject?) -> AnyObject? {
        
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    @IBAction func filter(){
        
//        if UIScreen.main.sizeType == .iPhone5 {
//          //  self.performSegue(withIdentifier: "Filter_5s", sender: self)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Filter_5") as! FilterViewController_5
//            vc.delegate = self
//            self.present(vc, animated: true, completion: nil)
//        }
//        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Filter_6") as! FilterViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        //}
    }

}
