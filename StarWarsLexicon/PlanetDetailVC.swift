//
//  PlanetDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/29.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class PlanetDetailVC: UIViewController {

    var detailPlanet: Planet!
    let embeddedRelatedFilmSegueName = "embeddedRelatedFilmsInPlanetDetailVC"
    let relatedFilmSegue = "showRelatedFilmFromPlanetVC"
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var populationLbl: UILabel!
    @IBOutlet weak var climateLbl: UILabel!
    @IBOutlet weak var terrainLbl: UILabel!
    @IBOutlet weak var diameterLbl: UILabel!
    @IBOutlet weak var gravityLbl: UILabel!
    @IBOutlet weak var surfaceWaterLbl: UILabel!
    @IBOutlet weak var rotationPeriodLbl: UILabel!
    @IBOutlet weak var orbitalPeriodLbl: UILabel!
    
    //View will appear??
    override func viewDidLoad() {
        super.viewDidLoad()

        let nilLabel = "Unknown"

        if let planet = detailPlanet {

            nameLbl.text = planet.name.capitalized
            if planet.population >= 0 {
                populationLbl.text = "\(planet.population)"
            } else {
                populationLbl.text = nilLabel
            }
            climateLbl.text = planet.climate.capitalized
            terrainLbl.text = planet.terrain.capitalized
            if planet.diameter >= 0 {
                diameterLbl.text = "\(planet.diameter)"
            } else {
                diameterLbl.text = nilLabel
            }
            if planet.gravity >= 0 {
                gravityLbl.text = "\(planet.gravity)"
            } else {
                gravityLbl.text = nilLabel
            }
            if planet.surfaceWater >= 0 {
                surfaceWaterLbl.text = "\(planet.surfaceWater)"
            } else {
                surfaceWaterLbl.text = nilLabel
            }
            if planet.rotationPeriod >= 0 {
                rotationPeriodLbl.text = "\(planet.rotationPeriod)"
            } else {
                rotationPeriodLbl.text = nilLabel
            }
            if planet.orbitalPeriod >= 0 {
                orbitalPeriodLbl.text = "\(planet.orbitalPeriod)"
            } else {
                orbitalPeriodLbl.text = nilLabel
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case relatedFilmSegue?:
            if let filmDetailVC = segue.destination as? FilmDetailVC {
                if let relatedFilm = sender as? Film {
                    filmDetailVC.film = relatedFilm//The selected film
                }
            }
            
        case embeddedRelatedFilmSegueName?:
            if let planet = detailPlanet {
                if let relatedFilmVC = segue.destination as? RelatedFilmCollectionVC {
                    //Set segue delegate
                    relatedFilmVC.segueDelegate = self
                    
                    //Convert NSSet to NSArray to array
                    let relatedFilms = planet.toFilm?.allObjects as? [Film]
                    relatedFilmVC.relatedFilms = relatedFilms
                }
            }
        default:
            preconditionFailure("Unidentified segue name")
        }
    }
}

extension PlanetDetailVC: SegueDelegate {
    func segueToRelatedFilm(_ film: Film) {
        performSegue(withIdentifier: relatedFilmSegue, sender: film)
    }
}
