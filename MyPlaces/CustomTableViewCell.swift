//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 29/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratingStar: RatingControl!
    

}
