//
//  MandirCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 27/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class MandirCell: UITableViewCell {

    @IBOutlet var mandirTitle : UILabel?
    @IBOutlet var phone : UILabel?
    @IBOutlet var fax : UILabel?
    @IBOutlet var email : UILabel?
    @IBOutlet var contactPerson : UILabel?
    @IBOutlet var accomodation : UILabel?
    @IBOutlet var food : UILabel?
    @IBOutlet var addressDetails : UILabel?
    @IBOutlet var mandirImg : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCellWithMandirDetails(mandir : String, phonenumber :  String, faxnumber : String, emailadd : String, contact : String, accomodate : String, foods : String, address : String) {
        
        mandirTitle?.text = mandir
        phone?.text = phonenumber
        fax?.text = faxnumber
        email?.text = emailadd
        contactPerson?.text = contact
        accomodation?.text = accomodate
        food?.text = foods
        addressDetails?.text = address
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellWithImageWithText(url : String){
        mandirImg?.loadImageUsingCacheWithUrlString(urlString: url)
    }
    
}
