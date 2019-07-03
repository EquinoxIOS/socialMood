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
    
    @IBOutlet weak var imageFromLast: UIImageView!
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
            if !FB.isSelected{
                FB.setImage(#imageLiteral(resourceName: "FB"), for: .normal)
                FB.isSelected = true
            } else {
                FB.setImage(#imageLiteral(resourceName: "FBOFF"), for: .normal)
                FB.isSelected = false
            }
            
        case INST:
            if !INST.isSelected{
                INST.setImage(#imageLiteral(resourceName: "IG"), for: .normal)
                INST.isSelected = true
            } else {
                INST.setImage(#imageLiteral(resourceName: "IGOFF"), for: .normal)
                INST.isSelected = false
            }
            
        case TWT:
            if !TWT.isSelected{
                TWT.setImage(#imageLiteral(resourceName: "TT"), for: .normal)
                TWT.isSelected = true
            } else {
                TWT.setImage(#imageLiteral(resourceName: "TTOFF"), for: .normal)
                TWT.isSelected = false
            }
        case WHATS:
            if !WHATS.isSelected{
                WHATS.setImage(#imageLiteral(resourceName: "WA"), for: .normal)
                WHATS.isSelected = true
            } else {
                WHATS.setImage(#imageLiteral(resourceName: "WAOFF"), for: .normal)
                WHATS.isSelected = false
            }
        case YTB:
            if !YTB.isSelected{
                YTB.setImage(#imageLiteral(resourceName: "YT"), for: .normal)
                YTB.isSelected = true
            } else {
                YTB.setImage(#imageLiteral(resourceName: "YTOFF"), for: .normal)
                YTB.isSelected = false
            }
        case SNP:
            if !SNP.isSelected{
                SNP.setImage(#imageLiteral(resourceName: "SC"), for: .normal)
                SNP.isSelected = true
            } else {
                SNP.setImage(#imageLiteral(resourceName: "SCOFF"), for: .normal)
                SNP.isSelected = false
            }
        default:
            print("asd")
        }
        
        
        
    }
    
 
    
    @IBAction func addResults(_ sender: Any) {
        if FB.isSelected{
            recievedEmoji.socialSelected.append("FB")
        }
        if INST.isSelected{
            recievedEmoji.socialSelected.append("IG")
        }
        if TWT.isSelected{
            recievedEmoji.socialSelected.append("TT")
        }
        if WHATS.isSelected{
            recievedEmoji.socialSelected.append("WA")
        }
        if YTB.isSelected{
            recievedEmoji.socialSelected.append("YT")
        }
        if SNP.isSelected{
            recievedEmoji.socialSelected.append("SC")
        }
        recievedEmoji.note = textFieldNote.text!
        
        testingBDD()
        performSegue(withIdentifier: "seg2", sender: self)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageFromLast.image = UIImage(named: recievedEmoji.emojiSelected)
        
        initButtns()
        // Do any additional setup after loading the view.
    }
    
    
    
    func testingBDD() {
        var social = [String]()
        for i in recievedEmoji.socialSelected {
            //social.append(i)
            social.append(i)
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
        
        //        let decoder = JSONDecoder()
        //        decoder.dateDecodingStrategy = .iso8601
        //
        //        do {
        //            let fileData = try Data(contentsOf: url)
        //            let readJson = try decoder.decode([Mood].self, from: fileData)
        //            print("-=======- Read -=======-")
        //            print(readJson)
        //
        //        } catch {
        //            print(error)
        //        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func initButtns() {
        FB.isSelected = false
        INST.isSelected = false
        YTB.isSelected = false
        SNP.isSelected = false
        WHATS.isSelected = false
        TWT.isSelected = false
    }
}
