//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by ninjaKID on 1/24/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }
    
    
 

}
