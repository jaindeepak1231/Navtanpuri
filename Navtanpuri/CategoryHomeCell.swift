//
//  CategoryHomeCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class CategoryHomeCell: UICollectionViewCell {
    
    @IBOutlet var categoryTitle: UILabel?
    @IBOutlet var categoryImg: UIImageView?
    
    func configureCellWithIconTitle(name: String , imgName : String ) {
    
        categoryTitle?.text = name
        categoryImg?.image = UIImage(named: imgName)
    }

}
