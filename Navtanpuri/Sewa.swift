//
//  Sewa.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class Sewa: NSObject {

    var sewaDescription : String?
    var sewaTitle : String?
    var donate : String?
    
    init(dictionary : [String : AnyObject]) {
        super.init()
        sewaDescription = dictionary["sewa_desc"] as? String
        sewaTitle = dictionary["sewa_title"] as? String
        donate = dictionary["donate"] as? String

        
    }

}
