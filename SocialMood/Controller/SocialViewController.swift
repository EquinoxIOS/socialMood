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
        //print(recievedEmoji.emojiSelected)
        let mood = Mood(emojiSelected: "\(recievedEmoji.emojiSelected)", note: "\(String(describing: recievedEmoji.note))", socialSelected: ["\(String(describing: recievedEmoji.socialSelected))"])
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let jsonUrlString = Bundle.main.url(forResource: "mood", withExtension: "json")
        guard let url = jsonUrlString else { return }
        
        do {
            let data = try encoder.encode([mood])
            
            if let string = String(data: data, encoding: .utf8) {
                print("-=======- Write -=======-")
                print("JSON String : " + string)
                
                try data.write(to: url)
                //try string.encode(to: url as! Encoder)
            }
            
        } catch {
            print("Error serializing JSON :", error)
        }
        
        
        super.viewDidLoad()
        
//        let dico = defaults.dictionaryRepresentation()
        
//        let jsonUrlString = Bundle.main.url(forResource: "mood", withExtension: "json")
//        guard let url = jsonUrlString else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let fileData = try Data(contentsOf: url)
            let readJson = try decoder.decode([Mood].self, from: fileData)
            print("-=======- Read -=======-")
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
