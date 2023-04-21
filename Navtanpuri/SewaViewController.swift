//
//  SewaViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SewaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sewaTable : UITableView!
    
    var donateValues = [String]()
    var sewaDescription = [String]()
    var sewaTitle = [String]()
    var sewa = [Sewa]()
    var sewaDictionary = [String: Sewa]()
    var processView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.navigationTitle.sewa
        // Navigation Controller Changes
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        
        openService(country: Connection.sewaForIndia)
        self.sewaTable.estimatedRowHeight = 128.0
        self.sewaTable.rowHeight = UITableView.automaticDimension
        
        processView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        processView.center = view.center
        view.addSubview(processView)
        
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Sewa For India")
            openService(country: Connection.sewaForIndia)
        case 1:
            print("Sewa For USA")
            openService(country: Connection.sewaForUSA)
        default:
            break;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sewaTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sewaCell", for: indexPath) as! SewaCell
        
        cell.dataWithSewaDescription(title: sewaTitle[indexPath.row], description: sewaDescription[indexPath.row], donate: donateValues[indexPath.row])
        cell.contentView.alpha = 0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            cell.contentView.alpha = 1.0
        })
    }
    func openService(country : String) {
        
        processView.startAnimating()
        self.sewaDescription = []
        self.sewaTitle = []
        self.donateValues = []
        
        Alamofire.request(Connection.open.sewaService, method: .post, parameters: [:], encoding: country, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            print("Response : \(response)")
            do {
                let json = try JSON(data: response.data!)

                for i in 0...json["date"].arrayValue.count {
                    let donation = json["date"][i]["donate"].stringValue
                    let sewaDesc = json["date"][i]["sewa_desc"].stringValue
                    let sewaTitle = json["date"][i]["sewa_title"].stringValue

                    self.donateValues.append(donation)
                    self.sewaDescription.append(sewaDesc)
                    self.sewaTitle.append(sewaTitle)
                }
                print(self.sewaTitle)
                print(self.sewaDescription)
                print(self.donateValues)

                DispatchQueue.main.async {
                    self.sewaTitle.removeLast()
                    self.sewaTable.reloadData()
                    self.processView.stopAnimating()
                }
            }
            catch {
            }
        }
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    

}
