//
//  SidebarMenu.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 18/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class SidebarMenu: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var reuseidentifier = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath as IndexPath) as! MenuCell
            
        cell.configureCellWithIconTitle(name:Constants.items[indexPath.row], imgName: "\(Constants.items[indexPath.row])-White")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if app_Delegate.InterNet == "Not Available" {
            self.showMessage(title : "No Internet Connection", message: "Please check your Internet Connection and try again")
        }
        else {
            if indexPath.row == 0{
                let objLiveEvent = self.storyboard?.instantiateViewController(withIdentifier: "LiveEventVC") as! LiveEventVC
                pushViewWithNavBar(controller: objLiveEvent)
            }
            if indexPath.row == 1{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LiveDarshan") as! DarshanViewController
                pushViewWithNavBar(controller: secondViewController)
            }
            if indexPath.row == 2 {
                let shreeTartamVC = self.storyboard?.instantiateViewController(withIdentifier: "ShreeTartamSagarVC") as! ShreeTartamSagarVC
                pushViewWithNavBar(controller: shreeTartamVC)
            }
            if indexPath.row == 3 {
                let objGurukolamVC = self.storyboard?.instantiateViewController(withIdentifier: "EGurukulamVC") as! EGurukulamVC
                pushViewWithNavBar(controller: objGurukolamVC)
            }
            if indexPath.row == 4{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsView") as! NewsViewController
                pushViewWithNavBar(controller: secondViewController)
            }
            if indexPath.row == 5{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventsView") as! EventsController
                pushViewWithNavBar(controller: secondViewController)
            }
            if indexPath.row == 6 {
            }
            if indexPath.row == 7 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MandirDirectory") as! MandirDirectoryController
                pushViewWithNavBar(controller: secondViewController)
            }
            
            if indexPath.row == 8 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SewaView") as! SewaViewController
                pushViewWithNavBar(controller: secondViewController)
            }
            if indexPath.row == 9 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LineageView") as! LineageViewController
                pushViewWithNavBar(controller: secondViewController)
                //            self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            if indexPath.row == 10 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackView") as! FeedBackController
                pushViewWithNavBar(controller: secondViewController)
                //            self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            if indexPath.row == 11 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "IntrectionView") as! IntrectionController
                pushViewWithNavBar(controller: secondViewController)
                //            self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            if indexPath.row == 12 {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "JapView") as! JapViewController
                pushViewWithNavBar(controller: secondViewController)
                //            self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }
    }
    
    
    func pushViewWithNavBar(controller : UIViewController)
    {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.barTintColor = UIColor(red:0.09, green:0.09, blue:0.32, alpha:1.0)
        navigationController.setViewControllers([controller], animated: true)
        self.revealViewController().navigationController?.navigationBar.tintColor = UIColor.white
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }

    
    func showMessage (title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
