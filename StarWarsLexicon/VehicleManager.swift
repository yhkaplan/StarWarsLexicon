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
    private func addVehicle(_ service: VehicleService, to index: Int) -> Vehicle? {
        
        //JSON guards cleared, so test for CoreData prerequisite
        let vehicle = Vehicle(entity: Vehicle.entity(), insertInto: moc)
        
        vehicle.name = service.name
        vehicle.model = service.model
        vehicle.vehicleClass = service.vehicleClass
        vehicle.manufacturer = service.manufacturer
        vehicle.itemURL = service.url
        
        vehicle.itemName = service.name
        vehicle.category = "vehicle"
        
        // MARK: - Setting related films
        if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: service.toFilm) {
            //Set value
            vehicle.toFilm = relatedFilmSet
        }
        
        vehicle.costInCredits = Double(service.costInCredits) ?? Double(-1)
        vehicle.length = Double(service.length) ?? Double(-1)
        vehicle.numberOfCrewMembers = Int64(service.numberOfCrewMembers) ?? Int64(-1)
        vehicle.numberOfPassengers = Int64(service.numberOfPassengers) ?? Int64(-1)
        vehicle.maximumAtmosphericSpeed = Double(service.maxAtmosphericSpeed) ?? Double(-1)
        
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
    
    // MARK: - Used for search 
    
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
            dataService.fetchItem(at: url, for: .vehicle, completion: { (result) in
                switch result {
                case let .success(vehicleService):
                    if let vehicleService = vehicleService as? VehicleService {
                        if let vehicle = self.addVehicle(vehicleService, to: index) {
                            completion(vehicle)
                        } else {
                            print("JSON parsing error")
                            completion(nil)
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            })
            completion(nil)
        }
    }
    
}
