//
//  CustomTableViewCell.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/02/12.
//

import UIKit


class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        containerView.layer.addSublayer(border)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
}
