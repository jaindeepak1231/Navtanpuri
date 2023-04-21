//
//  NotificationTableCell.swift
//  Navtanpuri
//
//  Created by deepak jain on 26/02/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
