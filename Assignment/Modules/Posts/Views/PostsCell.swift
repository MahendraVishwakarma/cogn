//
//  PostsCell.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  static let identifier = "PostsCell"
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
