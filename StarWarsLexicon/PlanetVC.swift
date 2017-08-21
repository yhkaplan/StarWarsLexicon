//
//  PlanetVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class PlanetVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataService = DataService()
    var planetManager: PlanetManager?
    var searchMode = false
    
    let planetSegueName = "showPlanet"
    let planetCellReuseIdentifier = "PlanetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        planetManager = PlanetManager()
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case planetSegueName?:
            if let planetDetailVC = segue.destination as? PlanetDetailVC {
                if let planet = sender as? Planet {
                    //print("Planet set")
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planetCellReuseIdentifier, for: indexPath) as? SWCell {
            
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
        return planetManager?.planetCount ?? 0
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
//        tapGestureRecognizer.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
