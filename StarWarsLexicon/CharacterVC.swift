//
//  CharacterVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

//Conforms to too many things: must seperate out
class CharacterVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataService = DataService()
    var characterManager: CharacterManager?
//    var characterURLCache = [String]()
    var searchMode = false
    
    let characterSegueName = "showCharacter"
    let characterCellReuseIdentifier = "CharacterCell"
    
    //Cache then deinitialize everything in viewDidDisappear??
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        characterManager = CharacterManager()
        
        searchBar.returnKeyType = UIReturnKeyType.done
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
                //DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.characterSegueName, sender: character)
                //}
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
            return cell //Is this return in the right place?
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            //filteredCharacterArray = characterArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
