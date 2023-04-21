//
//  GranthTableCell.swift
//  Navtanpuri
//
//  Created by deepak jain on 10/09/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class GranthTableCell: UITableViewCell {
    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblGranthName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
