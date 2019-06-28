//
//  HistoryTableViewCell.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var socialImageView1: UIImageView!
    @IBOutlet weak var socialImageView2: UIImageView!
    @IBOutlet weak var socialImageView3: UIImageView!
    @IBOutlet weak var socialImageView4: UIImageView!
    @IBOutlet weak var socialImageView5: UIImageView!
    @IBOutlet weak var socialImageView6: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(emojiAsset: String, emojiName: String, note: String?, social1Asset: String?, social2Asset: String?, social3Asset: String?, social4Asset: String?, social5Asset: String?, social6Asset: String? ) {
        
        emojiImageView.image = UIImage(named: emojiAsset)
        emojiLabel.text = emojiName
        noteLabel.text = note
        
        if let social1 = social1Asset { socialImageView1.image = UIImage(named: social1)}
        if let social2 = social2Asset { socialImageView2.image = UIImage(named: social2)}
        if let social3 = social3Asset { socialImageView3.image = UIImage(named: social3)}
        if let social4 = social4Asset { socialImageView4.image = UIImage(named: social4)}
        if let social5 = social5Asset { socialImageView5.image = UIImage(named: social5)}
        if let social6 = social6Asset { socialImageView6.image = UIImage(named: social6)}
    }
}
