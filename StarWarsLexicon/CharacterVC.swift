//
//  CharacterVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CharacterVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: SWSearchBar!
    
    let dataService = DataService()
    var characterManager: CharacterManager?
    
    let characterSegueName = "showCharacter"
    let characterCellReuseIdentifier = "CharacterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        characterManager = CharacterManager()
        
        self.hideKeyboardUponTouch()
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case characterSegueName?:
            if let characterDetailVC = segue.destination as? CharacterDetailVC {
                if let character = sender as? Character {
                    characterDetailVC.character = character
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

//MARK: Collection view functions

extension CharacterVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
}

extension CharacterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        characterManager?.getCharacter(at: indexPath.row, completion: { (character) in
            
            if let character = character {
                self.performSegue(withIdentifier: self.characterSegueName, sender: character)
            }
        })
    }
}

extension CharacterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCellReuseIdentifier, for: indexPath) as? SWCell {
        
            characterManager?.getCharacter(at: indexPath.row, completion: { (character) in
                if let character = character {
                    DispatchQueue.main.async {
                      cell.configureCell(character)
                    }
                }
            })
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterManager?.characterCount ?? 0
    }
}

//MARK: Search bar

extension CharacterVC: UISearchBarDelegate {    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //Change text color to white
//        searchBar.textColor = UIColor.white
        
        //Change keyboard hiding settingsc
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        characterManager?.loadLocalCharacters()
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchTerm = searchBar.text, searchTerm != "" {
            characterManager?.loadCharacters(with: searchTerm)
        } else {
            characterManager?.loadLocalCharacters()
        }
        collectionView.reloadData()
    }
}
