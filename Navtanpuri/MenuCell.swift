//
//  MenuCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 18/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
 
 
    @IBOutlet var nameTitle : UILabel?
    @IBOutlet var iconImg : UIImageView?

    func configureCellWithIconTitle(name: String , imgName : String ) {
        
        nameTitle?.text = name
        iconImg?.image = UIImage(named: imgName)
    }
}
