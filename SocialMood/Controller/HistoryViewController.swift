//
//  HistoryViewController.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate {
    
    var tabSocial: [Social] = []
    var moodJson: [Mood]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabSocial.append(Social(name: "FB", assetName: "FB"))
        tabSocial.append(Social(name: "FB", assetName: "FB"))
        // Do any additional setup after loading the view.
        
        
        // L'Affichage
        let jsonUrlString = Bundle.main.url(forResource: "mood", withExtension: "json")
        guard let url = jsonUrlString else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let fileData = try Data(contentsOf: url)
            let readJson = try decoder.decode([Mood].self, from: fileData)
            print("-=======- Read -=======-")
            print(readJson)
        
            moodJson = readJson
            
        } catch {
            print(error)
        }
    
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        var moodSocial = [String]()
        
        var socialSelect = moodJson![0].socialSelected
        
        for social in socialSelect {
            moodSocial.append(social)
        }
        
     
        cell.configure(emojiAsset: moodJson![0].emojiSelected, emojiName: moodJson![0].emojiSelected,
                       socialAsset: moodSocial , note: moodJson![0].note  )
    
        return cell
        
    }
    
    
}
