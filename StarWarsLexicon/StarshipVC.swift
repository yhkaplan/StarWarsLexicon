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
    var searchMode = false
    
    let starshipSegueName = "showStarship"
    let starshipCellReuseIdentifier = "StarshipCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        starshipManager = StarshipManager()
        
        searchBar.returnKeyType = UIReturnKeyType.done
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
                //DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.starshipSegueName, sender: starship)
                //}
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
            return cell //Is this return in the right place?
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
//            filteredStarshipArray = starshipArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
            collectionView.reloadData()
        } else {
            searchMode = false
            collectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //tapGestureRecognizer.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
