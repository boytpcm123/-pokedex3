//
//  Pokemon.swift
//  pokedex3
//
//  Created by ninjaKID on 1/3/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    var name:String {
        return _name
    }

    var pokedexId:Int {
        return _pokedexId
    }

    init(name:String, pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
		
    
}
