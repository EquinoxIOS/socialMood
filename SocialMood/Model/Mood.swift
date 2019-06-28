//
//  Mood.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import Foundation

struct Mood {
    var emojiSelected: String
    var date: Date
    var note: String?
    var socialSelected: [Social]
    
    init(emojiSelected: String, date: Date, note: String?,  socialSelected: [Social]) {
        self.emojiSelected = emojiSelected
        self.date = Date()
        self.note = note
        self.socialSelected = socialSelected
    }
    
}
