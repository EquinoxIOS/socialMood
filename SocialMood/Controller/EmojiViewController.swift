//
//  ViewController.swift
//  SocialMood
//
//  Created by Zain Zafar on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class EmojiViewController: UIViewController {

    @IBOutlet weak var dateT: UILabel!
    
    @IBOutlet weak var sadest: UIButton!
    
    @IBOutlet weak var sad: UIButton!
    
    @IBOutlet weak var neutral: UIButton!
    
    @IBOutlet weak var happier: UIButton!
    
    @IBOutlet weak var happiest: UIButton!
    
    @IBOutlet weak var animatingLabel: UILabel!
    
    var emojiSelected: Emoji!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateAppName()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "seg1"){
            let displayVC = segue.destination as! SocialViewController
            displayVC.recievedEmoji = emojiSelected
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        switch sender {
        case sadest:
            emojiSelected = Emoji(name: "Angry", assetName: "Angry")
        case sad:
            emojiSelected = Emoji(name: "Sad", assetName: "Sad")
        case neutral:
            emojiSelected = Emoji(name: "Middle", assetName: "Middle")
        case happier:
            emojiSelected = Emoji(name: "Cool", assetName: "Cool")
        case happiest:
            emojiSelected = Emoji(name: "Happy", assetName: "Happy")
        default:
            print("Unexpected error!")
        }
        self.performSegue(withIdentifier: "seg1", sender: self)
    }
    
    func loadDate(){
        let dat = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateT.text = dateFormatter.string(from: dat)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateAppName() {
        animatingLabel.text = ""
        
        let appName = "How are you?"
        
        // New code using Timer class
        
        let characters = appName.map { $0 }
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
            if index < appName.count {
                let char = characters[index]
                self?.animatingLabel.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
            }
        })
        
    }
}
