//
//  VehicleVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class VehicleVC: UIViewController, VehicleVCDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var vehicleManager: VehicleManager?
    var searchMode = false
    
    var cellCount = 20//0
    let vehicleSegueName = "showVehicle"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        vehicleManager = VehicleManager(vehicleVCDelegate: self)
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        vehicleManager?.getVehicleCount()
    }
    
    func updateCount(_ vehicleCount: Int) {
        cellCount = vehicleCount
        collectionView.reloadData()
    }
    
    //MARK: Keyboard dismissal
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tapGestureRecognizer.isEnabled = false
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
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.vehicleSegueName, sender: vehicle)
                }
            }
        })
    }
}

extension VehicleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCell", for: indexPath) as? SWCell {
            
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
        return cellCount
    }
}

extension VehicleVC: UISearchBarDelegate {
    //MARK: Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
//            filteredVehicleArray = vehicleArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
            collectionView.reloadData()
        } else {
            searchMode = false
            collectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapGestureRecognizer.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
