//
//  RelatedFilmCollectionVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/25.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

protocol SegueDelegate {
    func segueToRelatedFilm(_ film: Film)
}

private let reuseIdentifier = "RelatedFilmCell"

class RelatedFilmCollectionVC: UICollectionViewController {
    
    var segueDelegate: SegueDelegate?
    
    //Related film array is filled via dependency injection from embedded segue 
    //which takes the NSSet of related Film objects from Planet/Character/Vehicle/Starship
    var relatedFilms: [Film]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedFilm = relatedFilms?[indexPath.row] {
            //Tell parent to segue to related film
            segueDelegate?.segueToRelatedFilm(selectedFilm)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.0, height: 85.0)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedFilms?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RelatedFilmCell {
        
            if let relatedFilm = relatedFilms?[indexPath.row] {
            // Configure the cell
                cell.configureCell(relatedFilm)
                return cell
            }
        }
        fatalError("Object not found")
    }
}
