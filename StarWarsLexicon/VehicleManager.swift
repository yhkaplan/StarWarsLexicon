//
//  VehicleManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

class VehicleManager {
    let dataService = DataService()
    
    private var vehicleURLCache = [String]()
    private var vehicleURLCount: Int { return vehicleURLCache.count }
    
    private var vehicles = [Vehicle?]()
    var vehicleCount: Int { return vehicles.count }
    
    init() {
        vehicleURLCache = APIService.sharedInstance.getURLStringCache(for: .vehicle)
        
        loadLocalVehicles()
        
        let countDifference = vehicleURLCount - vehicleCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                vehicles.append(nil)
            }
        }
    }
    
    private func loadLocalVehicles() {
        //CoreData initializers
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            vehicles = try managedContext.fetch(Vehicle.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    //There appears to be a large number of vehicles that don't actually load properly on the APIs end
    //Think of workaround using pages containing items
    private func addVehicle(_ json: [String : Any], to index: Int) -> Vehicle? {

        guard let name = json["name"] as? String else {
            print("Parsing error with vehicle name")
            return nil
        }
        
        guard let model = json["model"] as? String else {
            print("Parsing error with vehicle model")
            return nil
        }
        
        guard let vehicleClass = json["vehicle_class"] as? String else {
            print("Parsing error with vehicle class")
            return nil
        }
        
        guard let manufacturer = json["manufacturer"] as? String else {
            print("Parsing error with vehicle manufacturer")
            return nil
        }
        
        guard let url = json["url"] as? String else {
            print("Parsing error with vehicle url")
            return nil
        }
        
        //JSON guards cleared, so test for CoreData prerequisite
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let vehicle = Vehicle(entity: Vehicle.entity(), insertInto: managedContext)
        
        vehicle.name = name
        vehicle.model = model
        vehicle.vehicleClass = vehicleClass
        vehicle.manufacturer = manufacturer
        vehicle.itemURL = url
        
        vehicle.itemName = name
        vehicle.category = "vehicle"
        
        if let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Double(costInCreditsString) {
            vehicle.costInCredits = costInCredits
        } else {
            vehicle.costInCredits = Double(0)
        }
        
        if let lengthString = json["length"] as? String, let length = Double(lengthString) {
            vehicle.length = length
        } else {
            vehicle.length = Double(0)
        }
        
        if let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Int64(numberOfCrewMembersString) {
            vehicle.numberOfCrewMembers = numberOfCrewMembers
        } else {
            vehicle.numberOfCrewMembers = Int64(0)
        }
        
        if let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Int64(numberOfPassengersString) {
            vehicle.numberOfPassengers = numberOfPassengers
        } else {
            vehicle.numberOfPassengers = Int64(0)
        }
        
        if let maxAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maxAtmosphericSpeed = Double(maxAtmosphericSpeedString) {
            vehicle.maximumAtmosphericSpeed = maxAtmosphericSpeed
        } else {
            vehicle.maximumAtmosphericSpeed = Double(0)
        }
        
        //print(vehicle.description)
        
        do {
            try managedContext.save()
            vehicles[index] = vehicle
            return vehicle
        } catch let error as NSError {
            print("Could not save \(error), \(error)")
            print("Could not save vehicle at index \(index)")
            return nil
        }
    }
    
    func getVehicle(at index: Int, completion: @escaping (Vehicle?) -> Void) {
        guard index < vehicles.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let vehicle = vehicles[index] {
            completion(vehicle)
        } else {
            let urlString =  vehicleURLCache[index]
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            //print("Download url is \(url)")
            dataService.fetchItem(at: url, completion: { (result) in
                switch result {
                case let .success(vehicleJSON):
                    //switch to main thread?
                    if let vehicle = self.addVehicle(vehicleJSON, to: index) {
                        completion(vehicle)
                    } else {
                        print("JSON parsing error")
                        completion(nil)
                    }
                case let .failure(error):
                    print(error)
                }
            })
            completion(nil)
        }
    }
    
}