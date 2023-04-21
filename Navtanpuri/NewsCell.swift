//
//  NewsCell.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 10/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet var newsDescription: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataWithNewsDescription(news: String) {
        newsDescription?.text = news
    }


}
