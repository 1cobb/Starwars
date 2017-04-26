//
//  VehiclesModel.swift
//  StarWars
//
//  Created by James Cobb on 4/11/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import Foundation

struct Vehicle {
    
    let name: String
    let make: String
    let cost: String
    let length: String?
    let vehicleClass: String
    let crew: String
    
}

extension Vehicle: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String,
            let make = JSON["model"] as? String,
            let cost = JSON["cost_in_credits"] as? String,
            let length = JSON["length"] as? String,
            let vehicleClass = JSON["vehicle_class"] as? String,
            let crew = JSON["crew"] as? String else {
            return nil
        }
        
        self.name = name
        self.make = make
        self.cost = cost
        self.length = length
        self.vehicleClass = vehicleClass
        self.crew = crew
    }
}
