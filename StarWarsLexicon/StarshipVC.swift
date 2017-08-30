//
//  StarshipVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class StarshipVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataService = DataService()
    var starshipManager: StarshipManager?
    
    let starshipSegueName = "showStarship"
    let starshipCellReuseIdentifier = "StarshipCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        starshipManager = StarshipManager()
        
        self.hideKeyboardUponTouch()
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case starshipSegueName?:
            if let starshipDetailVC = segue.destination as? StarshipAndVehicleDetailVC {
                if let starship = sender as? Starship {
                    starshipDetailVC.starship = starship
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
    
//MARK: Collection View Functions

extension StarshipVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 60.0)
    }
}

extension StarshipVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        starshipManager?.getStarship(at: indexPath.row, completion: { (starship) in
            
            if let starship = starship {
                    self.performSegue(withIdentifier: self.starshipSegueName, sender: starship)
            }
        })
    }
}

extension StarshipVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: starshipCellReuseIdentifier, for: indexPath) as? SWCell {
            
            starshipManager?.getStarship(at: indexPath.row, completion: { (starship) in
                if let starship = starship {
                    DispatchQueue.main.async {
                        cell.configureCell(starship)
                    }
                }
            })
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starshipManager?.starshipCount ?? 0
    }
}

//MARK: Search Bar Functions
extension StarshipVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //To implement placeholder text color changing etc
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        starshipManager?.loadLocalStarships()
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchTerm = searchBar.text, searchTerm != "" {
            starshipManager?.loadStarships(with: searchTerm)
        } else {
            starshipManager?.loadLocalStarships()
        }
        collectionView.reloadData()
    }
}
