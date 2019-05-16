//
//  LocationsTableViewCell.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 15/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    @IBOutlet weak var studentURL: UILabel!
    @IBOutlet weak var StudentName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
