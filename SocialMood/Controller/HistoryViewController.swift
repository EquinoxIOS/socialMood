//
//  HistoryViewController.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var tabSocial: [Social] = []
    var moods: [Mood] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tabSocial.append(Social(name: "FB", assetName: "FB"))
        //        tabSocial.append(Social(name: "FB", assetName: "FB"))
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        let mood = moods[indexPath.row]
        
        var moodSocial = [String]()
        let socialSelect = mood.socialSelected
        for social in socialSelect {
            moodSocial.append(social)
        }
        
        cell.configure(emojiAsset: mood.emojiSelected,
                       emojiName: mood.emojiSelected,
                       socialAsset: moodSocial,
                       note: mood.note,
                       date: mood.date)
        return cell
    }
}
