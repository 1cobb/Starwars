//
//  Swapi.swift
//  StarWars
//
//  Created by James Cobb on 3/29/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import Foundation

enum SWAPI: Endpoint {
    case people
    case vehicles
    case starships
    
    var baseURL: URL {
        return URL(string: "http://swapi.co/api/")!
    }
    
    var path: String {
        
        switch self {
        case .people:
            return "people/"
            
        case .vehicles:
            return "vehicles/"
            
        case .starships:
            return "starships/"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        return URLRequest(url: url)
    }
}
        


final class SWAPIClient: APIClient {
    
    let configuration: URLSessionConfiguration
    var session: URLSession {
        return URLSession(configuration: self.configuration)
    }
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    
    // MARK: Character
    
    func fetchCharacters(_ completion: @escaping (APIResult<[Character]>) -> Void) {
        let request = SWAPI.people.request
        
        fetch(request, parse: { json -> [Character]? in
            
            if let characters = json["results"] as? [[String: AnyObject]] {
                return characters.flatMap { characterDictionary in
                    return Character(JSON: characterDictionary)
                }
            } else {
                return nil
            }
        }, completion: completion)
    }
        
    
    // Fetching home for Character
    func fetchCharacterHome(_ character: Character, completion: @escaping(APIResult<Planet>) -> Void) {
            
            if let url = character.home {
                let url = URL(string: url)!
                let request = URLRequest(url: url)
                
                fetch(request, parse: { json -> Planet? in
                    
                    return Planet(JSON: json)
                    
                }, completion: completion)
            }
        }

        
        
    // MARK: Vehicles
        
        func fetchVehicles(_ completion: @escaping (APIResult<[Vehicle]>) -> Void) {
            let request = SWAPI.vehicles.request
            
            fetch(request, parse: { json -> [Vehicle]? in
                
                if let vehicles = json["results"] as? [[String: AnyObject]] {
                    return vehicles.flatMap { vehiclesDictionary in
                        return Vehicle(JSON: vehiclesDictionary)
                    }
                } else {
                    return nil
                }
            }, completion: completion)
        }
        
        
    // MARK: Starships
        
        func fetchStarships(_ completion: @escaping (APIResult<[Starship]>) -> Void) {
            let request = SWAPI.starships.request
            
            fetch(request, parse: { json -> [Starship]? in
                
                if let starships = json["results"] as? [[String: AnyObject]] {
                    return starships.flatMap { starshipDictionary in
                        return Starship(JSON: starshipDictionary)
                    }
                } else {
                    return nil
                }
            }, completion: completion)
            

        
            
        

}
}
    
















































