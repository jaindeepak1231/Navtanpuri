//
//  DonorTableCell.swift
//  Navtanpuri
//
//  Created by deepak jain on 12/04/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class DonorTableCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSubSeva: UILabel!
    @IBOutlet var lblINR: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
