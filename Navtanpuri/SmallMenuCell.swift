//
//  SmallMenuCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 18/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class SmallMenuCell: UICollectionViewCell {
    
    @IBOutlet var nameTitle : UILabel?
    
    func configureCellWithImageWithText(title : String){
        
        nameTitle?.text = title
    }

}
