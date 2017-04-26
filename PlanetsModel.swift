//
//  PlanetsModel.swift
//  StarWars
//
//  Created by James Cobb on 4/25/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import Foundation

struct Planet {
    
    let name: String?
}

extension Planet: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
    
    
}
