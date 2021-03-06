//
//  VehicleVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class VehicleVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataService = DataService()
    var vehicleManager: VehicleManager?
    
    let vehicleSegueName = "showVehicle"
    let vehicleCellReuseIdentifier = "VehicleCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        vehicleManager = VehicleManager()
        
        self.hideKeyboardUponTouch()
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case vehicleSegueName?:
            if let vehicleDetailVC = segue.destination as? StarshipAndVehicleDetailVC {
                if let vehicle = sender as? Vehicle {
                    vehicleDetailVC.vehicle = vehicle
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

//MARK: Collection view functions
extension VehicleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 60.0)
    }
}

extension VehicleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vehicleManager?.getVehicle(at: indexPath.row, completion: { (vehicle) in
            
            if let vehicle = vehicle {
                self.performSegue(withIdentifier: self.vehicleSegueName, sender: vehicle)
            }
        })
    }
}

extension VehicleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vehicleCellReuseIdentifier, for: indexPath) as? SWCell {
            
            vehicleManager?.getVehicle(at: indexPath.row, completion: { (vehicle) in
                if let vehicle = vehicle {
                    DispatchQueue.main.async {
                        cell.configureCell(vehicle)
                    }
                }
            })
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleManager?.vehicleCount ?? 0
    }
}

//MARK: Search bar

extension VehicleVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //TO implement: placeholder text turning white, etc
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        vehicleManager?.loadLocalVehicles()
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchTerm = searchBar.text, searchTerm != "" {
            vehicleManager?.loadVehicles(with: searchTerm)
        } else {
            vehicleManager?.loadLocalVehicles()
        }
        collectionView.reloadData()
    }
}
