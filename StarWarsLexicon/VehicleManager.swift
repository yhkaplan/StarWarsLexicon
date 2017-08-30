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
    let filmManager = FilmManager()
    
    //MOC = Managed Object Context
    var moc: NSManagedObjectContext
    
    let sortByName = NSSortDescriptor(key: "itemName", ascending: true)
    
    private var vehicleURLCache = [String]()
    private var vehicleURLCount: Int { return vehicleURLCache.count }
    
    private var vehicles = [Vehicle?]()
    var vehicleCount: Int { return vehicles.count }
    
    init() {
        //Set NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not set Managed Object Context")
        }
        self.moc = appDelegate.persistentContainer.viewContext
        
        vehicleURLCache = APIService.sharedInstance.getURLStringCache(for: .vehicle)
        
        loadLocalVehicles()
        
        let countDifference = vehicleURLCount - vehicleCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                vehicles.append(nil)
            }
        }
    }
    
    func loadLocalVehicles() {
        do {
            vehicles = try moc.fetch(Vehicle.fetchRequest())
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
        let vehicle = Vehicle(entity: Vehicle.entity(), insertInto: moc)
        
        vehicle.name = name
        vehicle.model = model
        vehicle.vehicleClass = vehicleClass
        vehicle.manufacturer = manufacturer
        vehicle.itemURL = url
        
        vehicle.itemName = name
        vehicle.category = "vehicle"
        
        //MARK: - Setting related films
        if let filmURLStrings = json["films"] as? [String] {
            if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: filmURLStrings) {
                //Set value
                vehicle.toFilm = relatedFilmSet
            }
        }
        
        if let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Double(costInCreditsString) {
            vehicle.costInCredits = costInCredits
        } else {
            vehicle.costInCredits = Double(-1)
        }
        
        if let lengthString = json["length"] as? String, let length = Double(lengthString) {
            vehicle.length = length
        } else {
            vehicle.length = Double(-1)
        }
        
        if let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Int64(numberOfCrewMembersString) {
            vehicle.numberOfCrewMembers = numberOfCrewMembers
        } else {
            vehicle.numberOfCrewMembers = Int64(-1)
        }
        
        if let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Int64(numberOfPassengersString) {
            vehicle.numberOfPassengers = numberOfPassengers
        } else {
            vehicle.numberOfPassengers = Int64(-1)
        }
        
        if let maxAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maxAtmosphericSpeed = Double(maxAtmosphericSpeedString) {
            vehicle.maximumAtmosphericSpeed = maxAtmosphericSpeed
        } else {
            vehicle.maximumAtmosphericSpeed = Double(-1)
        }
        
        //print(vehicle.description)
        
        //vehicle 62 crashing, not reproducible
        do {
            try moc.save()
            vehicles[index] = vehicle
            return vehicle
        } catch let error as NSError {
            print("Could not save \(error), \(error)")
            print("Could not save vehicle at index \(index)")
            return nil
        }
    }
    
    //MARK: - Used for search 
    
    func loadVehicles(with text: String) {
        //Create fetch request
        let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
        
        //Add predicate with text string
        //C in CD means case insensitive, d means diacritic insensitive
        //"%K CONTAINS[cd] %@" = search for keypath containing input
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Vehicle.itemName), text)
        
        fetchRequest.sortDescriptors = [sortByName]
        
        do {
            vehicles = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
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
