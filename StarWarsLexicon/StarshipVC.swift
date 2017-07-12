//
//  StarshipVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class StarshipVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/starships/")
    var searchMode = false
    
    private var starshipArray = [Starship]()
    private var filteredStarshipArray = [Starship]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        initializeStarships()
//        for i in 0...30 {
//            let newStarship = Starship(name: "starship starship starship starship\(i)")
//            self.starshipArray.append(newStarship)
//        }
//        self.collectionView.reloadData()
    }

    //MARK: DataService controller
    
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
    
    //MARK: Keyboard dismissal
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tapGestureRecognizer.isEnabled = false
    }
    
    //MARK: Segue function
    
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
    
    //MARK: Search Bar Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            filteredStarshipArray = starshipArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
        var starship: Starship!
        
        if searchMode {
            starship = filteredStarshipArray[indexPath.row]
        } else {
            starship = starshipArray[indexPath.row]
        }
        performSegue(withIdentifier: "showStarship", sender: starship)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarshipCell", for: indexPath) as? SWCell {
            
            if searchMode {
                cell.configureCell(filteredStarshipArray[indexPath.row])
            } else {
                cell.configureCell(starshipArray[indexPath.row])
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredStarshipArray.count
        }
        return starshipArray.count
    }
}
