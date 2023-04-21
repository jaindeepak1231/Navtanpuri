//
//  EventTableCell.swift
//  Navtanpuri
//
//  Created by deepak jain on 09/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell, UIScrollViewDelegate {

    var selection = 0
    var interestedX = CGFloat()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    @IBOutlet var mandirTitle : UILabel?
    @IBOutlet var dateTime : UILabel?
    @IBOutlet var detailTitle : UILabel?
    @IBOutlet var descriptionDetails : UILabel?
    @IBOutlet var objscrlloView: UIScrollView!
    @IBOutlet var viewPageControl: UIView!
    @IBOutlet var PageControl: UIPageControl!
    @IBOutlet var constraint_page_scroll_height: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        objscrlloView.backgroundColor = UIColor.clear
    }

    
    func configureCellWithMandirDetails(mandir : String, date :  String, templeTitle : String, details : String, images: [String]) {
        
        //        let attrStr = try! NSAttributedString(
        //            data: details.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
        //            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
        //            documentAttributes: nil)
        
        mandirTitle?.text = mandir
        dateTime?.text = date
        detailTitle?.text = templeTitle
        descriptionDetails?.text = details
        
        
        
        //let imagees = arrEventImages[indexPath.row] as! NSMutableArray
        print(images)
        
        if images.count == 0 {
            viewPageControl.isHidden = true
            constraint_page_scroll_height.constant = 0
        }
        else {
            viewPageControl.isHidden = false
            constraint_page_scroll_height.constant = 195
            objscrlloView.delegate = self;
            let sel = selection + 1
            PageControl.currentPage = sel
            PageControl.numberOfPages = images.count
            
            //....................  SET FOLLOWING PEOPLE ARE INTERESTED .............................//
            objscrlloView.showsHorizontalScrollIndicator = false
            objscrlloView.showsVerticalScrollIndicator = false
            interestedX = objscrlloView.frame.origin.x
            
            for i in 0..<images.count {
                
                let imgPic = UIImageView(frame: CGRect(x: interestedX, y: -20.0, width: screenWidth, height: 195))
                imgPic.backgroundColor = UIColor.clear
                imgPic.contentMode = .scaleAspectFit
                
                
                let strImgLink = images[i]
                imgPic.loadImageUsingCacheWithUrlString(urlString: strImgLink)
                
                objscrlloView.addSubview(imgPic)
                interestedX = interestedX + screenWidth
                print("\(interestedX)")
                
            }
            //SET THE SCROLL VIEW WIDHT
            objscrlloView.contentSize = CGSize(width: interestedX, height: 170)
            objscrlloView.isPagingEnabled = true
            
            let XPosition = Int(screenWidth) * selection
            objscrlloView.setContentOffset(CGPoint(x: XPosition, y: 0), animated: true)
        }
        
    }
    
    
    
    //........................ UIScrollView Delegate...........................................//
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fractionalPage: Float = Float(objscrlloView.contentOffset.x) / Float(screenWidth)
        //    scrollviewPageIndex=
        
        print(String(lround(Double(fractionalPage))))
        
        let selVal = Int(lround(Double(fractionalPage)))
        app_Delegate.ImgSelection = selVal
        //selVal = selVal + 1
        
        PageControl.currentPage = selVal
        //) + " of " + String(arrImage.count)
        //objPageControl.currentPage = lround(Double(fractionalPage))
    }
    
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString.init(data: d, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
