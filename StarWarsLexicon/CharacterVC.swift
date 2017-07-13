//
//  CharacterVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CharacterVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/people/")
    var searchMode = false
    
    private var characterArray = [Character]()
    private var filteredCharacterArray = [Character]()
    
    //Cache then deinitialize everything in viewDidDisappear??
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.isEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        initializeCharacters()
    }
    
    //MARK: DataService controller
    
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
                        print("The next URL is \(nextURL)")
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
    
    //MARK: Keyboard dismissal
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        tapGestureRecognizer.isEnabled = false
    }
    
    //MARK: Segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCharacter"?:
            if let characterDetailVC = segue.destination as? CharacterDetailVC {
                if let character = sender as? Character {
                    characterDetailVC.character = character
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //MARK: Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchBar.text, searchTerm != "" {
            searchMode = true
            filteredCharacterArray = characterArray.filter({$0.name.localizedStandardRange(of: searchTerm) != nil})
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
    
    //MARK: Collection view functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var character: Character!
        
        if searchMode {
            character = filteredCharacterArray[indexPath.row]
        } else {
            character = characterArray[indexPath.row]
        }
        performSegue(withIdentifier: "showCharacter", sender: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as? SWCell {
        
            if searchMode {
                cell.configureCell(filteredCharacterArray[indexPath.row])
            } else {
                cell.configureCell(characterArray[indexPath.row])
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredCharacterArray.count
        }
        return characterArray.count
    }
}
