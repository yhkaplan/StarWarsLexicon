//
//  CollectionVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/people/")
    
    private var characterArray = [Character]()
    
    //Cache then deinitialize everything in viewDidDisappear??
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        initializeCharacters()
    }
    
    func initializeCharacters() {
        
        guard let url = url else {
            //throw error
            return
        }
        
        self.dataService.fetchObjects(category: .character, url: url) { (result) -> Void in
            
            //print("Result is \(result)")
            switch result {
            case let .characterSuccess(characters, nextURL):
                
                DispatchQueue.main.async {
                    
                    print("Retrieved \(characters.count) characters")
                    if !characters.isEmpty {
                        self.characterArray.append(contentsOf: characters)
                        self.collectionView.reloadData()
                        //self.organizeCharactersByName()
                    }
                    
                    if let nextURL = nextURL {
                        self.url = nextURL
                        print("The next URl is \(nextURL)")
                        self.initializeCharacters()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SWCell", for: indexPath) as? SWCell {
        
        cell.configureCell(characterArray[indexPath.row])
        
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterArray.count
    }
}
