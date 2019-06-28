//
//  Social.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 28/06/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import Foundation
import UIKit

struct Social {
    let name: String
    let assetName : String
    
    init(name: String, assetName: String) {
        self.name = name
        self.assetName = name
    }
}

struct Emoji {
    let name: String
    let assetName : String
    
    init(name: String, assetName: String) {
        self.name = name
        self.assetName = name
}
}

struct Theme {
    let name: String
    let backgroundColor: UIColor
    let textColor: UIColor
}
