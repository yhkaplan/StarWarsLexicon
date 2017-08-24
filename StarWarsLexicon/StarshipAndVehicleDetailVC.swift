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
            if starship.costInCredits >= 0 {
                costLbl.text = "\(starship.costInCredits) credits"
            } else {
                costLbl.text = nilLabel
            }
            if starship.length >= 0 {
                lengthLbl.text = "\(starship.length) meters"
            } else {
                lengthLbl.text = nilLabel
            }
            if starship.numberOfCrewMembers >= 0 {
                numberOfCrewMembersLbl.text = "\(starship.numberOfCrewMembers)"
            } else {
                numberOfCrewMembersLbl.text = nilLabel
            }
            if starship.numberOfPassengers >= 0 {
                numberOfPassengersLbl.text = "\(starship.numberOfPassengers)"
            } else {
                numberOfPassengersLbl.text = nilLabel
            }
            if starship.maxAtmosphericSpeed >= 0 {
                maxAtmosphericSpeedLbl.text = "\(starship.maxAtmosphericSpeed)"
            } else {
                maxAtmosphericSpeedLbl.text = nilLabel
            }
            if starship.hyperdriveRating >= 0 {
                hyperdriveRatingLbl.text = "\(starship.hyperdriveRating)"
            } else {
                hyperdriveRatingLbl.text = nilLabel
            }
            
        } else if let vehicle = vehicle {
            //Hide hyperdrive labels
            hyperdriveRatingLbl.isHidden = true
            hyperdriveDescriptionLbl.isHidden = true
            
            nameLbl.text = vehicle.name.capitalized
            modelLbl.text = vehicle.model.capitalized
            classLbl.text = vehicle.vehicleClass.capitalized
            manufacturerLbl.text = vehicle.manufacturer.capitalized
            if vehicle.costInCredits >= 0 {
                costLbl.text = "\(vehicle.costInCredits) credits"
            } else {
                costLbl.text = nilLabel
            }
            if vehicle.length >= 0 {
                lengthLbl.text = "\(vehicle.length) meters"
            } else {
                lengthLbl.text = nilLabel
            }
            if vehicle.numberOfCrewMembers >= 0 {
                numberOfCrewMembersLbl.text = "\(vehicle.numberOfCrewMembers)"
            } else {
                numberOfCrewMembersLbl.text = nilLabel
            }
            if vehicle.numberOfPassengers >= 0 {
                numberOfPassengersLbl.text = "\(vehicle.numberOfPassengers)"
            } else {
                numberOfPassengersLbl.text = nilLabel
            }
            if vehicle.maximumAtmosphericSpeed >= 0 {
                maxAtmosphericSpeedLbl.text = "\(vehicle.maximumAtmosphericSpeed)"
            } else {
                maxAtmosphericSpeedLbl.text = nilLabel
            }
        }
    }
}
