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
    
    @IBOutlet weak var FB: UIButton!
    @IBOutlet weak var INST: UIButton!
    @IBOutlet weak var TWT: UIButton!
    @IBOutlet weak var WHATS: UIButton!
    @IBOutlet weak var YTB: UIButton!
    @IBOutlet weak var SNP: UIButton!
    @IBOutlet weak var textFieldNote: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func appBtnPressed(_ sender: UIButton) {
        
        switch sender {
        case FB:
            FB.isHighlighted = !FB.isHighlighted

        case INST:
            INST.isHighlighted = !INST.isHighlighted

        case TWT:
            TWT.isHighlighted = !TWT.isHighlighted
        case WHATS:
        WHATS.isHighlighted = !WHATS.isHighlighted
        case YTB:
        YTB.isHighlighted = !YTB.isHighlighted
        case SNP:
        SNP.isHighlighted = !SNP.isHighlighted
        default:
            print("asd")
        }
        
        
        
    }
    
    
    
    
    
    @IBAction func addResults(_ sender: Any) {
        if !FB.isHighlighted{
            recievedEmoji.socialSelected.append("FB")
        }
        if !INST.isHighlighted{
            recievedEmoji.socialSelected.append("IG")
        }
        if !TWT.isHighlighted{
            recievedEmoji.socialSelected.append("TT")
        }
        if !WHATS.isHighlighted{
            recievedEmoji.socialSelected.append("WA")
        }
        if !YTB.isHighlighted{
            recievedEmoji.socialSelected.append("YT")
        }
        if !SNP.isHighlighted{
            recievedEmoji.socialSelected.append("SC")
        }
        recievedEmoji.note = textFieldNote.text!
        
//        print("gsdhgfhjsdgfhgsdjhgfhjgsdhjgfjsdhfgjhsgdfh")
//        print(recievedEmoji.note)
//        print(recievedEmoji.socialSelected)
//        print("gsdhgfhjsdgfhgsdjhgfhjgsdhjgfjsdhfgjhsgdfh")

         testingBDD()
        performSegue(withIdentifier: "seg2", sender: self)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        //print(recievedEmoji.emojiSelected)
        FB.isHighlighted = true
        INST.isHighlighted = true
        TWT.isHighlighted = true
        WHATS.isHighlighted = true
        YTB.isHighlighted = true
        SNP.isHighlighted = true
        
        super.viewDidLoad()
       
        

        // Do any additional setup after loading the view.
    }


    
    func testingBDD() {
        var social = [String]()
        for i in recievedEmoji.socialSelected {
            //social.append(i)
            social = [i]
        }
        
        let mood = Mood(emojiSelected: "\(recievedEmoji.emojiSelected)", note: recievedEmoji.note, socialSelected: social)
        
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
