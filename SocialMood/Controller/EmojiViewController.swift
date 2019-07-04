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
    @IBOutlet weak var camBtn: UIBarButtonItem!
    
    @IBAction func passF(_ sender: Any) {
        performSegue(withIdentifier: "seg3", sender: self)
    }
    
    //let camBtn: UIBarButtonItem? = UIBarButtonItem(title: "📷", style: .plain, target: self, action: #selector(nextTapped))
    
    //var emojiSelected: Emoji!
    var objectToSend: Mood!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextTapped))
//        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(nextTapped))
        
//        navigationItem.rightBarButtonItems = [add, play]
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(nextTapped))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateAppName()
        self.loadDate()
        
        
    }
    
    
    
    
//    @IBAction func tt( sender: toto) {
//        performSegue(withIdentifier: "seg3", sender: self)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "seg1"){
            let displayVC = segue.destination as! SocialViewController
            displayVC.recievedEmoji = objectToSend
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        switch sender {
        case sadest:
            //emojiSelected = Emoji(name: "Angry", assetName: "Angry")
            objectToSend = Mood(emojiSelected: "Angry", note: "", socialSelected:[])
        case sad:
            //emojiSelected = Emoji(name: "Sad", assetName: "Sad")
            objectToSend = Mood(emojiSelected: "Sad", note: "", socialSelected: [])
        case neutral:
            //emojiSelected = Emoji(name: "Middle", assetName: "Middle")
            objectToSend = Mood(emojiSelected: "Middle", note: "", socialSelected: [])
        case happier:
            //emojiSelected = Emoji(name: "Cool", assetName: "Cool")
            objectToSend = Mood(emojiSelected: "Cool", note: "", socialSelected: [])
        case happiest:
            //emojiSelected = Emoji(name: "Happy", assetName: "Happy")
            objectToSend = Mood(emojiSelected: "Happy", note: "", socialSelected: [])
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
