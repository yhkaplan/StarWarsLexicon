//
//  StarshipVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class StarshipVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/starships/")
    
    private var starshipArray = [Starship]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        initializeStarships()
    }

    func initializeStarships() {
        guard let url = url else {
            //Error
            return
        }
        
        self.dataService.fetchObjects(category: .starship, url: url) { (result) -> Void in
            switch result {
            case let .starshipSuccess(starships, nextURL):
                
                DispatchQueue.main.async {
                    print("Retrieved \(starships.count) starships")
                    if !starships.isEmpty {
                        self.starshipArray.append(contentsOf: starships)
                        self.collectionView.reloadData()
                        //self.organizeStarshipsByName()
                    }
                    
                    if let nextURL = nextURL {
                        self.url = nextURL
                        print("The next url is \(nextURL)")
                        self.initializeStarships()
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
        case "showStarship"?:
            if let starshipDetailVC = segue.destination as? StarshipAndVehicleDetailVC {
                if let starship = sender as? Starship {
                    starshipDetailVC.starship = starship
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var starship: Starship!
        
        starship = starshipArray[indexPath.row]
        performSegue(withIdentifier: "showStarship", sender: starship)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarshipCell", for: indexPath) as? StarshipCell {
            
            cell.configureCell(starshipArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starshipArray.count
    }
}
