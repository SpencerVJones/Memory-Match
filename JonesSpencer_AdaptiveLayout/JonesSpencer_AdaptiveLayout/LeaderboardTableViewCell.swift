//  LeaderboardTableViewCell.swift
//  JonesSpencer_AdaptiveLayout
//  Created by Spencer Jones on 5/28/24.

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    // Cell outlets
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var MovesLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var DateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
