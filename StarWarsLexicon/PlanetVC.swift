//
//  PlanetVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class PlanetVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/planets/")
    
    private var planetArray = [Planet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        initializePlanets()
    }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var planet: Planet!
        
        planet = planetArray[indexPath.row]
        
        performSegue(withIdentifier: "showPlanet", sender: planet)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as? PlanetCell {
            
            cell.configureCell(planetArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planetArray.count
    }
}
