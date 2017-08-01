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
    @IBOutlet weak var hyperdriveDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nilLabel = "Unknown / N/A"
        
        if let starship = starship {
            nameLbl.text = starship.name.capitalized
            modelLbl.text = starship.model.capitalized
            classLbl.text = starship.starshipClass.capitalized
            manufacturerLbl.text = starship.manufacturer.capitalized
////            if let cost = starship.costInCredits {
//                costLbl.text = "\(cost) credits"
////            } else {
////                costLbl.text = nilLabel
////            }
//            if let length = starship.length {
//                lengthLbl.text = "\(length) meters"
//            } else {
//                lengthLbl.text = nilLabel
//            }
//            if let numberOfCrewMembers = starship.numberOfCrewMembers {
//                numberOfCrewMembersLbl.text = "\(numberOfCrewMembers)"
//            } else {
//                numberOfCrewMembersLbl.text = nilLabel
//            }
//            if let numberOfPassengers = starship.numberOfPassengers {
//                numberOfPassengersLbl.text = "\(numberOfPassengers)"
//            } else {
//                numberOfPassengersLbl.text = nilLabel
//            }
//            if let maxAtmosphericSpeed = starship.maxAtmosphericSpeed {
//                maxAtmosphericSpeedLbl.text = "\(maxAtmosphericSpeed)"
//            } else {
//                maxAtmosphericSpeedLbl.text = nilLabel
//            }
//            if let hyperdriveRating = starship.hyperdriveRating {
//                hyperdriveRatingLbl.text = "\(hyperdriveRating)"
//            } else {
//                hyperdriveRatingLbl.text = nilLabel
//            }
            
        } else if let vehicle = vehicle {
            //Hide hyperdrive labels
            hyperdriveRatingLbl.isHidden = true
            hyperdriveDescriptionLbl.isHidden = true
            
            nameLbl.text = vehicle.name.capitalized
            modelLbl.text = vehicle.model.capitalized
            classLbl.text = vehicle.vehicleClass.capitalized
            manufacturerLbl.text = vehicle.manufacturer.capitalized
//            if let cost = vehicle.costInCredits {
//                costLbl.text = "\(cost) credits"
//            } else {
//                costLbl.text = nilLabel
//            }
//            if let length = vehicle.length {
//                lengthLbl.text = "\(length) meters"
//            } else {
//                lengthLbl.text = nilLabel
//            }
//            if let numberOfCrewMembers = vehicle.numberOfCrewMembers {
//                numberOfCrewMembersLbl.text = "\(numberOfCrewMembers)"
//            } else {
//                numberOfCrewMembersLbl.text = nilLabel
//            }
//            if let numberOfPassengers = vehicle.numberOfPassengers {
//                numberOfPassengersLbl.text = "\(numberOfPassengers)"
//            } else {
//                numberOfPassengersLbl.text = nilLabel
//            }
//            if let maximumAtmosphericSpeed = vehicle.maximumAtmosphericSpeed {
//                maxAtmosphericSpeedLbl.text = "\(maximumAtmosphericSpeed)"
//            } else {
//                maxAtmosphericSpeedLbl.text = nilLabel
//            }
        }
    }
}
