//
//  SocialViewController.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController {
    var recievedEmoji: Mood!
    
    override func viewDidLoad() {
        
        let mood = Mood(emojiSelected: ":)", note: "fhdjsh", socialSelected: ["fb"])
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(mood)
            
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            
        } catch {
            print("Error serializing JSON :", error)
        }
        
        
        super.viewDidLoad()
        
        //        let dico = defaults.dictionaryRepresentation()
        
        let jsonUrlString = Bundle.main.url(forResource: "mood", withExtension: "json")
        guard let url = jsonUrlString else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let fileData = try Data(contentsOf: url)
            let readJson = try decoder.decode([Mood].self, from: fileData)
            print(readJson)
            
        } catch {
            print(error)
        }

        // Do any additional setup after loading the view.
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
