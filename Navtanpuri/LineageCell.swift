//
//  LineageCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 11/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class LineageCell: UITableViewCell {

    @IBOutlet var years : UILabel?
    @IBOutlet var nameTitle : UILabel?
    @IBOutlet var avtarImg : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellWithImageWithText(title : String, year : String, url : String){
        years?.text = year
        nameTitle?.text = title
        avtarImg?.loadImageUsingCacheWithUrlString(urlString: url)
    }

}
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString : String){
        
        self.image = nil
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            // download hit an error so lets return out
            if error != nil {
                print(error ?? "Error")
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
            }
        }).resume()
        
    }
}
