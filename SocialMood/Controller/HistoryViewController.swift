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
    var groupedMood: [(key: String, value: [Mood])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moods.sort{
            $0.date > $1.date
        }

        groupedMood = Dictionary(grouping: moods){ (mood) -> String in
            return mood.date.dayString!
            }.sorted { $0.0 > $1.0 }
        
    }

}

extension HistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMood.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        
        
        if groupedMood[section].key == Date().dayString {
            return "Today"
        }
        else{
            return groupedMood[section].key
        }
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMood[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
//        let mood = moods[indexPath.row]
        let mood = groupedMood[indexPath.section].value[indexPath.row]
        
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

extension Date {
    var dayString: String? {
        
        let dateFormatter = DateFormatter ()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
