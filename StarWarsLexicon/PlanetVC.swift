//
//  PlanetVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class PlanetVC: UIViewController, PlanetVCDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var planetManager: PlanetManager?
    var searchMode = false
    
    var cellCount = 20//0
    let planetSegueName = "showPlanet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        planetManager = PlanetManager(planetVCDelegate: self)
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        planetManager?.getPlanetCount()
    }
    
    func updateCount(_ planetCount: Int) {
        cellCount = planetCount
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
        case planetSegueName?:
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
}
    //MARK: Collection View Functions
    
extension PlanetVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
}

//Segue currently crashing for some reason
extension PlanetVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        planetManager?.getPlanet(at: indexPath.row, completion: { (planet) in
            if let planet = planet {
                //DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.planetSegueName, sender: planet)
                //}
            }
        })
    }
}

extension PlanetVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as? SWCell {
            
            planetManager?.getPlanet(at: indexPath.row, completion: { (planet) in
                if let planet = planet {
                    DispatchQueue.main.async {
                        cell.configureCell(planet)
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

//MARK: Search Bar Functions
extension PlanetVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            
//            filteredPlanetArray = planetArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
