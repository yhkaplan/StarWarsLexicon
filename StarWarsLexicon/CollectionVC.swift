//
//  CollectionVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataService = DataService()
    let swObjectStore = SWObjectStore()
    
    var filmArray = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        filmArray = makeTestData()
    }
    
    func makeTestData() -> [Film] {
        var testArray = [Film]()
        for i in 0...100 {
            testArray.append(Film(title: "Film \(i)", episodeID: i, openingCrawl: "Once upon a time, in a galaxy far, far away"))
        }
        return testArray
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SWCell", for: indexPath) as? SWCell {
        
        cell.configureCell(filmArray[indexPath.row])
        
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmArray.count
    }
}
