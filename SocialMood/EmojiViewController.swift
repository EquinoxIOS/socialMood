//
//  ViewController.swift
//  SocialMood
//
//  Created by Zain Zafar on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit

class EmojiViewController: UIViewController {

    @IBOutlet weak var animatingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        animatingLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateAppName()
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
