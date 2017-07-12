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
            if let population = planet.population {
                populationLbl.text = "\(population)"
            } else {
                populationLbl.text = nilLabel
            }
            climateLbl.text = planet.climate.capitalized
            terrainLbl.text = planet.terrain.capitalized
            if let diameter = planet.diameter {
                diameterLbl.text = "\(diameter)"
            } else {
                diameterLbl.text = nilLabel
            }
            if let gravity = planet.gravity {
                gravityLbl.text = "\(gravity)"
            } else {
                gravityLbl.text = nilLabel
            }
            if let surfaceWater = planet.surfaceWater {
                surfaceWaterLbl.text = "\(surfaceWater)"
            } else {
                surfaceWaterLbl.text = nilLabel
            }
            if let rotationPeriod = planet.rotationPeriod {
                rotationPeriodLbl.text = "\(rotationPeriod)"
            } else {
                rotationPeriodLbl.text = nilLabel
            }
            if let orbitalPeriod = planet.orbitalPeriod {
                orbitalPeriodLbl.text = "\(orbitalPeriod)"
            } else {
                orbitalPeriodLbl.text = nilLabel
            }
        }
    }
}
