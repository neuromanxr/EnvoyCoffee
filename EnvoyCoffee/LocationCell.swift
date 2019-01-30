//
//  LocationCell.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/27/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//

import UIKit
import Reusable

class LocationCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
