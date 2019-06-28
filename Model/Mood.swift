//
//  Mood.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import Foundation

struct Mood {
    var date: Date
    var note: String?
    var socialSelected: [Social]
    
    init(date: Date, note: String?,  socialSelected: [Social]) {
        self.date = Date()
        self.note = note
        self.socialSelected = socialSelected
    }
    
}
