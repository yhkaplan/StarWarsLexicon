//
//  VehicleManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

protocol VehicleVCDelegate {
    func updateCount(_ vehicleCount: Int)
}

//Suffers same parsing issues as starship manager

class VehicleManager {
    let dataService = DataService()
    
    private var vehicles = [Vehicle?]()
    var vehicleVCDelegate: VehicleVCDelegate
    
    var vehicleCount = 0 {
        didSet {
            vehicleVCDelegate.updateCount(vehicleCount)
        }
    }
    
    init(vehicleVCDelegate: VehicleVCDelegate) {
        self.vehicleVCDelegate = vehicleVCDelegate
        
        //CoreData code goes here
    }
    
    func getVehicleCount() {
        if let url = URL(string: "https://swapi.co/api/vehicles/") {
            dataService.fetchItemCount(url, completion: { (count) in
                if let count = count {
                    for _ in 0..<count {
                        self.vehicles.append(nil)
                    }
                    
                    self.vehicleCount = count
                }
            })
        }
    }
    
    private func addVehicle(_ json: [String : Any], to index: Int) -> Vehicle? {
        if let vehicle = Vehicle(json: json) {
            vehicles[index] = vehicle
            return vehicle
        }
        return nil
    }
    
    func getVehicle(at index: Int, completion: @escaping (Vehicle?) -> Void) {
        guard index < vehicles.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let vehicle = vehicles[index] {
            completion(vehicle)
        } else {
            if let url = URL(string: "https://swapi.co/api/vehicles/\(index+1)/") {
                print("Download url is \(url)")
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
            }
        }
        completion(nil)
    }
}
