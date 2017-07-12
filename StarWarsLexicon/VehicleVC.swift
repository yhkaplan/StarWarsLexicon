//
//  VehicleVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class VehicleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/vehicles/")
    var searchMode = false
    
    private var vehicleArray = [Vehicle]()
    private var filteredVehicleArray = [Vehicle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        initializeVehicles()
    }

    //MARK: DataService controller
    
    func initializeVehicles() {
        
        guard let url = url else {
            //throw an error
            return
        }
        
        self.dataService.fetchObjects(category: .vehicle, url: url) { (result) -> Void in
            switch result {
            case let .vehicleSuccess(vehicles, nextURL):
                
                DispatchQueue.main.async {
                    
                    print("Retrieved \(vehicles.count) vehicles")
                    if !vehicles.isEmpty {
                        self.vehicleArray.append(contentsOf: vehicles)
                        self.collectionView.reloadData()
                        //self.organizeVehiclesByName()
                    }
                    
                    if let nextURL = nextURL {
                        self.url = nextURL
                        print("The next URL is \(nextURL)")
                        self.initializeVehicles()
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
                break
            default:
                print("Error: wrong data read")
                break
            }
        }
    }
    
    //MARK: Keyboard dismissal
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tapGestureRecognizer.isEnabled = false
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showVehicle"?:
            if let vehicleDetailVC = segue.destination as? StarshipAndVehicleDetailVC {
                if let vehicle = sender as? Vehicle {
                    vehicleDetailVC.vehicle = vehicle
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //MARK: Search bar 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            filteredVehicleArray = vehicleArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
    
    //MARK: Collection view functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vehicle: Vehicle!
        
        if searchMode {
            vehicle = filteredVehicleArray[indexPath.row]
        } else {
            vehicle = vehicleArray[indexPath.row]
        }
        performSegue(withIdentifier: "showVehicle", sender: vehicle)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCell", for: indexPath) as? SWCell {
            
            if searchMode {
                cell.configureCell(filteredVehicleArray[indexPath.row])
            } else {
                cell.configureCell(vehicleArray[indexPath.row])
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredVehicleArray.count
        }
        return vehicleArray.count
    }
}
