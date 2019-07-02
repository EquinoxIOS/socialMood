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
    
    
    
    
    func configure(emojiAsset: String, emojiName: String, socialAsset: [String], note: String? = nil ) {
        
        emojiImageView.image = UIImage(named: emojiAsset)
        emojiLabel.text = emojiName
        noteLabel.text = note
        
//        socialImageView1.image = UIImage(named: social1Asset)
        
        switch socialAsset.count {
        case 1:
            socialImageView1.image = UIImage(named: socialAsset[0])
        
        case 2:
            socialImageView1.image = UIImage(named: socialAsset[0])
            socialImageView2.image = UIImage(named: socialAsset[1])
            
        case 3:
            socialImageView1.image = UIImage(named: socialAsset[0])
            socialImageView2.image = UIImage(named: socialAsset[1])
            socialImageView3.image = UIImage(named: socialAsset[2])
        case 4:
            socialImageView1.image = UIImage(named: socialAsset[0])
            socialImageView2.image = UIImage(named: socialAsset[1])
            socialImageView3.image = UIImage(named: socialAsset[2])
            socialImageView4.image = UIImage(named: socialAsset[3])
        case 5:
            socialImageView1.image = UIImage(named: socialAsset[0])
            socialImageView2.image = UIImage(named: socialAsset[1])
            socialImageView3.image = UIImage(named: socialAsset[2])
            socialImageView4.image = UIImage(named: socialAsset[3])
            socialImageView5.image = UIImage(named: socialAsset[4])
        case 6:
            socialImageView1.image = UIImage(named: socialAsset[0])
            socialImageView2.image = UIImage(named: socialAsset[1])
            socialImageView3.image = UIImage(named: socialAsset[2])
            socialImageView4.image = UIImage(named: socialAsset[3])
            socialImageView5.image = UIImage(named: socialAsset[4])
            socialImageView6.image = UIImage(named: socialAsset[5])
            
        default:
             socialImageView1.image = UIImage(named: socialAsset[0])
        }
    }
}
