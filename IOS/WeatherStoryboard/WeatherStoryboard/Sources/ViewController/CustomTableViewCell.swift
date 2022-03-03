//
//  CustomTableViewCell.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/02/12.
//

import UIKit


class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
}
