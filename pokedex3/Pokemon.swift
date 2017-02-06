//
//  Pokemon.swift
//  pokedex3
//
//  Created by ninjaKID on 1/3/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }
    
    var name:String {
        return _name
    }
    
    
    var pokedexId:Int {
        return _pokedexId
    }

    init(name:String, pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL, method: .get).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                let swiftyJsonVar = JSON(value)
                if let weight = swiftyJsonVar["weight"].string {
                    self._weight = weight
                }
                if let height = swiftyJsonVar["height"].string {
                    self._height = height
                }
                if let attack = swiftyJsonVar["attack"].int {
                    self._attack = String(attack)
                }
                if let defense = swiftyJsonVar["defense"].int {
                    self._defense = String(defense)
                }
                
                if let nextEvolutionLevel = swiftyJsonVar["evolutions"][0]["level"].int {
                    self._nextEvolutionLevel = String(nextEvolutionLevel)
                } else {
                    self._nextEvolutionLevel = ""
                }
               
                if let nextEvolutionId = swiftyJsonVar["evolutions"][0]["resource_uri"].string {
                    var newEvolutionId = nextEvolutionId.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                    newEvolutionId = newEvolutionId.replacingOccurrences(of: "/", with: "")
                    self._nextEvolutionId = newEvolutionId
                } else {
                    self._nextEvolutionId = ""
                }
                
                if let nextEvolutionName = swiftyJsonVar["evolutions"][0]["to"].string {
                    self._nextEvolutionName = nextEvolutionName
                } else {
                    self._nextEvolutionName = ""
                }
                
                print(self._nextEvolutionLevel)
                print(self._nextEvolutionId)
                print(self._nextEvolutionName)
                
                //Getting an array of string from a JSON Array
                let arrayTypesNames:NSMutableArray = []
                let arrayTypes =  swiftyJsonVar["types"].arrayValue.map({arrayTypesNames.add($0["name"].stringValue.capitalized)})
                if arrayTypes.count > 0 {
                    self._type = arrayTypesNames.componentsJoined(by: "/")
                }
     
                let arrayTypesDescriptions:NSMutableArray = []
                _ =  swiftyJsonVar["descriptions"].arrayValue.map({
                    if let path = String($0["resource_uri"].stringValue) {
                        let url = ("\(URL_BASE)\(path)")
                        Alamofire.request(url).responseJSON() { response in
                            switch response.result {
                                case .failure(let error):
                                print(error)
                            case .success(let value):
                                
                                let jsonDescription = JSON(value)
                                if let description:String = jsonDescription["description"].string {
                                    let newDescription:String = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    arrayTypesDescriptions.add(newDescription)
                                   
                                    self._description = newDescription
                                    
                                }
                            }
                            completed()
                            
                        }
                        
                    }
                    
                    
                })
                
                
                
               
            }

            completed()
            
        }
    }
		
    
}
