//
//  PlanetVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class PlanetVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/planets/")
    var searchMode = false
    
    private var planetArray = [Planet]()
    private var filteredPlanetArray = [Planet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        initializePlanets()
    }
    
    //MARK: DataService controller

    func initializePlanets(){
        guard let url = url else {
            //Error
            return
        }
        
        self.dataService.fetchObjects(category: .planet, url: url) { (result) -> Void in
            switch result {
            case let .planetSuccess(planets, nextURL):
                
                DispatchQueue.main.async {
                    print("Retrieved \(planets.count) planets")
                    if !planets.isEmpty {
                        self.planetArray.append(contentsOf: planets)
                        self.collectionView.reloadData()
                        //self.organizePlanetsByName()
                    }
                    
                    if let nextURL = nextURL {
                        self.url = nextURL
                        print("The next url is \(nextURL)")
                        self.initializePlanets()
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
        case "showPlanet"?:
            if let planetDetailVC = segue.destination as? PlanetDetailVC {
                if let planet = sender as? Planet {
                    print("Planet set")
                    planetDetailVC.detailPlanet = planet
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //MARK: Search Bar Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            
            filteredPlanetArray = planetArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
    
    //MARK: Collection View Functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var planet: Planet!
        
        if searchMode {
            planet = filteredPlanetArray[indexPath.row]
        } else {
            planet = planetArray[indexPath.row]
        }
        performSegue(withIdentifier: "showPlanet", sender: planet)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as? SWCell {
            
            if searchMode {
                cell.configureCell(filteredPlanetArray[indexPath.row])
            } else {
                cell.configureCell(planetArray[indexPath.row])
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredPlanetArray.count
        }
        return planetArray.count
    }
}
