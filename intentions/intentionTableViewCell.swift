//
//  intentionTableViewCell.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit

class intentionTableViewCell: UITableViewCell {
    
    //Mark: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressChart: progressChart!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
