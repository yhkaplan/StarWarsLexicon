//
//  CharacterVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

//Conforms to too many things: must seperate out
class CharacterVC: UIViewController, CharacterVCDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var characterManager: CharacterManager?
    var searchMode = false
    
    var cellCount = 20//0
    let characterSegueName = "showCharacter"
    
    //Cache then deinitialize everything in viewDidDisappear??
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        characterManager = CharacterManager(characterVCDelegate: self)
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        //This method informs characterManager that it should grab the count for maximum number of characters
        characterManager?.getCharacterCount()
    }
    
    func updateCount(_ characterCount: Int) {
        cellCount = characterCount
        collectionView.reloadData()
    }
    
    //MARK: Keyboard dismissal
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tapGestureRecognizer.isEnabled = false
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
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.characterSegueName, sender: character)
                }
            }
        })
    }
}

extension CharacterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as? SWCell {
        
            characterManager?.getCharacter(at: indexPath.row, completion: { (character) in
                if let character = character {
                    DispatchQueue.main.async {
                      //cell.configureCell(character)
                    }
                }
            })
            return cell //Is this return in the right place?
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
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
        tapGestureRecognizer.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
