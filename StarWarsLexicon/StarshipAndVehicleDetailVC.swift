//
//  StarshipAndVehicleDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/06.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class StarshipAndVehicleDetailVC: UIViewController {

    var starship: Starship!
    var vehicle: Vehicle!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var classLbl: UILabel!
    @IBOutlet weak var manufacturerLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var lengthLbl: UILabel!
    @IBOutlet weak var numberOfCrewMembersLbl: UILabel!
    @IBOutlet weak var numberOfPassengersLbl: UILabel!
    @IBOutlet weak var maxAtmosphericSpeedLbl: UILabel!
    @IBOutlet weak var hyperdriveRatingLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nilLabel = "Unknown / N/A"
        
        if let starship = starship {
            nameLbl.text = starship.name
            modelLbl.text = starship.model
            classLbl.text = starship.starshipClass
            manufacturerLbl.text = starship.manufacturer
            if let cost = starship.costInCredits {
                costLbl.text = "\(cost)"
            } else {
                costLbl.text = nilLabel
            }
            if let length = starship.length {
                lengthLbl.text = "\(length)"
            } else {
                lengthLbl.text = nilLabel
            }
            if let numberOfCrewMembers = starship.numberOfCrewMembers {
                numberOfCrewMembersLbl.text = "\(numberOfCrewMembers)"
            } else {
                numberOfCrewMembersLbl.text = nilLabel
            }
            if let numberOfPassengers = starship.numberOfPassengers {
                numberOfPassengersLbl.text = "\(numberOfPassengers)"
            } else {
                numberOfPassengersLbl.text = nilLabel
            }
            if let maxAtmosphericSpeed = starship.maxAtmosphericSpeed {
                maxAtmosphericSpeedLbl.text = "\(maxAtmosphericSpeed)"
            } else {
                maxAtmosphericSpeedLbl.text = nilLabel
            }
            if let hyperdriveRating = starship.hyperdriveRating {
                hyperdriveRatingLbl.text = "\(hyperdriveRating)"
            } else {
                hyperdriveRatingLbl.text = nilLabel
            }
            
        } else if let vehicle = vehicle {
            
        }
    }

}
