//
//  CharacterDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/30.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CharacterDetailVC: UIViewController {

    var character: Character!
//    let planetManager = PlanetManager() //This is to retreive homeworld
    var relatedFilmArray = [Film]()
    //private var homeworld: Planet?
    
    let dataService = DataService()
    
    @IBOutlet weak var filmCollectionView: UICollectionView!
    @IBOutlet weak var homeworldButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var homeworldLbl: UILabel!
    @IBOutlet weak var birthYearLbl: UILabel!
    @IBOutlet weak var eyeColorLbl: UILabel!
    @IBOutlet weak var skinColorLbl: UILabel!
    @IBOutlet weak var hairColorLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeworldButton.isEnabled = false
        let nilLabel = "Unknown"
        
        if let character = character {
            self.nameLbl.text = character.name.capitalized
            self.birthYearLbl.text = character.birthYear.capitalized
            self.eyeColorLbl.text = character.eyeColor.capitalized
            self.skinColorLbl.text = character.skinColor.capitalized
            self.hairColorLbl.text = character.hairColor.capitalized
            self.genderLbl.text = character.gender.capitalized
            if character.height > 0 {
                heightLbl.text = "\(character.height)"
            } else {
                heightLbl.text = nilLabel
            }
            if character.mass > 0 {
                massLbl.text = "\(character.mass)"
            } else {
                massLbl.text = nilLabel
            }
//
//            initializeHomeworld()
//            initializeRelatedFilms()
//            if let homeworld = planetManager.
        }
    }
    
//    @IBAction func showHomeworld(_ sender: UIButton) {
//        if let homeworld = homeworld {
//            performSegue(withIdentifier: "showHomeworld", sender: homeworld)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRelatedFilm"?:
            if let filmDetailVC = segue.destination as? FilmDetailVC {
                if let relatedFilm = sender as? Film {
                    filmDetailVC.film = relatedFilm
                }
            }
        case "showHomeworld"?:
            if let planetDetailVC = segue.destination as? PlanetDetailVC {
                if let homeworld = sender as? Planet {
                    planetDetailVC.detailPlanet = homeworld
                }
            }
        //ADD HERE FOR OTHER SEGUES
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
