//
//  ItemManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/23.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

//Add unit test to make sure that all View Controllers refer to the same object

/* Reason to make this a class: multiple view controllers can share a reference to the same instance. 
 If a struct had been used instead, difference instances of ItemManager would have been referenced.*/

protocol CharacterVCDelegate {
    func updateCount(_ characterCount: Int)
}

class ItemManager {
    let dataService = DataService()
    
    private var characters = [Character?]()
    var characterVCDelegate: CharacterVCDelegate
    
    var characterCount = 0 {
        didSet {
            characterVCDelegate.updateCount(characterCount)
        }
    }
    
    //deinit: saves to disk, calling save method
    
    //init: loads from CoreData
    init(characterVCDelegate: CharacterVCDelegate) {
        self.characterVCDelegate = characterVCDelegate
        
    }
    
    //Relocate this to API service w/ all URL methods
    func url(for category: Category) -> URL? {
        switch category {
        case .film:
            return URL(string: "")
        case .character:
            return URL(string: "https://swapi.co/api/people/")
        case .starship:
            return URL(string: "")
        case .planet:
            return URL(string: "")
        case .species:
            return URL(string: "")
        case .vehicle:
            return URL(string: "")
        }
    }
    
    func itemCount(for category: Category) {
        if let url = self.url(for: category) {
            dataService.fetchItemCount(url) { (count) in
                DispatchQueue.main.async {
                    if let count = count {
                        //When count updates, this optional array must be reset and then set to the same length
                        for _ in 0..<count {
                            self.characters.append(nil)
                        }
                        
                        //property observer calls updateCount method in VC
                        self.characterCount = count
                    }
                }
            }
        }
    }
    
    //Save new items func
    //This is needed for serializing the data when CoreData is integrated
    //Add new item func
    func add<T: SWCategory>(_ item: T, to index: Int) {
        switch item.category {
        case .character:
            if let character = item as? Character {
                //Check to make sure items aren't doubled
                //if !characters.contains(character) {
                    //characters.append(character)
                if index < characters.count {
                    characters[index] = character
                } else {
                    print("Tried inserting follow character to \(index): \(character)")
                }
            }
        default:
            //Add in other types
            break
        }
    }
    
    //One character is not downloading correctly: 17 Details not found
    func get(_ category: Category, at index: Int, completion: @escaping (Character?) -> Void) {
        switch category {
        case .character:
            //Check if data is in local cache
            if index < characters.count, let character = characters[index] {
                completion(character)
            //If not, use NW request to download, then add to local cache, then return
            } else {
                //Download data with helper function
                if let url = URL(string: "https://swapi.co/api/people/\(index+1)/") {
                    print("Data download URL is \(url)")
                    dataService.fetchCharacter(at: url, completion: { (result) in
                        switch result {
                        case let .success(character):
                            self.add(character, to: index)
                            completion(character)
                        case let .failure(error):
                            print(error)
                        }
                    })
                }
            }
        default:
            print("")
            break
            //Implement for other types
        }
        completion(nil)
    }
    
    //search: returned a filtered version of the data processed by CoreData filter
}
