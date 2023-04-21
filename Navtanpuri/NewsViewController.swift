//
//  NewsViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var newsTable : UITableView?
    
    var processView = UIActivityIndicatorView()
    var newsDescription = [String]()
    
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
        
        
        openService()
        self.title = Constants.navigationTitle.news
        processView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        processView.center = view.center
        view.addSubview(processView)

    }
    func openService() {
        
        
        Alamofire.request(Connection.open.newsService, method: .post, parameters: [:], encoding: Connection.forNews, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in

            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                    
                    for i in 0...json["date"].arrayValue.count{
                        let news = json["date"][i].stringValue
                        self.newsDescription.append(news)
                    }
                    print(self.newsDescription)
                    self.newsDescription.removeLast()
                    self.newsTable?.reloadData()
                }
                catch {
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsDescription.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.dataWithNewsDescription(news: self.newsDescription[indexPath.row])
        cell.contentView.alpha = 0
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            cell.contentView.alpha = 1.0
        })
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }

}
