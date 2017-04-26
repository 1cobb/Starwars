//
//  CharactersModel.swift
//  StarWars
//
//  Created by James Cobb on 4/11/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import Foundation

struct Character {
    
    let name: String
    let born: String
    let home: String?
    let height: String?
    let eyes: String
    let hair: String
    
}

extension Character: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String,
            let born = JSON["birth_year"] as? String,
            let home = JSON["homeworld"] as? String,
            let height = JSON["height"] as? String,
            let eyes = JSON["eye_color"] as? String,
            let hair = JSON["hair_color"] as? String else {
            return nil
        }
        self.name = name
        self.born = born
        self.home = home 
        self.height = height
        self.eyes = eyes
        self.hair = hair 
    }
}
