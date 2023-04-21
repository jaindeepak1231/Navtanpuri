//
//  SewaCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 11/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class SewaCell: UITableViewCell {

    @IBOutlet var sewaTitle : UILabel?
    @IBOutlet var sewaDesc : UILabel?
    @IBOutlet var donationValue : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func dataWithSewaDescription(title: String, description : String, donate : String) {
        
        let description = try! NSAttributedString(
            data: description.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        

        sewaTitle?.text = title
        sewaDesc?.attributedText = description
        sewaDesc?.font = UIFont.systemFont(ofSize: 14)
        donationValue?.text = "Donation Amount - Rs. \(donate)"
        
    }
}
