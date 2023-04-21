//
//  LineageViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LineageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lineageTable : UITableView?

    var durations = [String]()
    var titles = [String]()
    var imgUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Controller Changes
        self.title = Constants.navigationTitle.lineage
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        
        openService(type: Connection.lineage)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lineageCell", for: indexPath) as! LineageCell
        
        cell.configureCellWithImageWithText(title: titles[indexPath.row], year: durations[indexPath.row], url: imgUrls[indexPath.row])
        cell.contentView.alpha = 0
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            cell.contentView.alpha = 1.0
        })
    }

    func openService(type : String) {
        
        Alamofire.request(Connection.open.lineageService, method: .post, parameters: [:], encoding: type, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            print("Response : \(response)")
            
            DispatchQueue.main.async {
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                    
                    for i in 0...json["date"].arrayValue.count{
                        
                        let duration = json["date"][i]["L_Duration"].stringValue
                        let title = json["date"][i]["L_Title"].stringValue
                        let imgUrls = json["date"][i]["L_Image"].stringValue
                        
                        self.durations.append(duration)
                        self.titles.append(title)
                        self.imgUrls.append(imgUrls)
                        
                        print("\(self.durations)/ && \(self.titles)/ && \(self.imgUrls)")
                        self.lineageTable?.reloadData()
                    }
                }
                catch {
                }
            }
        }
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }

}
