//
//  CharacterManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/23.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

//Add unit test to make sure that all View Controllers refer to the same object

/* Reason to make this a class: multiple view controllers can share a reference to the same instance. 
 If a struct had been used instead, difference instances of ItemManager would have been referenced.*/

protocol CharacterVCDelegate {
    func updateCount(_ characterCount: Int)
}

class CharacterManager {
    let dataService = DataService()
    
    private var characters = [Character?]()
    var characterVCDelegate: CharacterVCDelegate
    
    var characterCount = 0 {
        didSet {
            characterVCDelegate.updateCount(characterCount)
        }
    }
    

    
    //deinit: saves to disk, calling save method
    //If there are still objects equal to nil in character array, then handle them
//    deinit {
//        let charactersToBeSaved: [Character] = characters.map {
//            if let character = $0 { return character }
//        }
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//    }
    
    //Make sure to persists cell count as well!
    
    //init: loads from CoreData
    init(characterVCDelegate: CharacterVCDelegate) {
        self.characterVCDelegate = characterVCDelegate
        //Make sure to persists cell count as well!
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //Make array equal to fetched contents
            characters = try managedContext.fetch(Character.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    //Relocate this to API service w/ all URL methods!!!
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
    
    func getCharacterCount() {
        if let url = URL(string: "https://swapi.co/api/people/") {
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
    private func addCharacter(_ json: [String : Any], to index: Int) -> Character? {
        
        guard let name = json["name"] as? String else {
            print("Parsing error with character name")
            return nil
        }

        guard let hairColor = json["hair_color"] as? String else {
            print("Parsing error with character hair color")
            return nil
        }

        guard let skinColor = json["skin_color"] as? String else {
            print("Parsing error with character skin color")
            return nil
        }

        guard let eyeColor = json["eye_color"] as? String else {
            print("Parsing error with character eye color")
            return nil
        }

        guard let birthYear = json["birth_year"] as? String else {
            print("Parsing error with character birth year")
            return nil
        }

        guard let gender = json["gender"] as? String else {
            print("Parsing error with character gender")
            return nil
        }

        guard let url = json["url"] as? String else {
            print("Parsing error with url")
            return nil
        }

        //Attempt conversation from json to NSManaged object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let character = Character(entity: Character.entity(), insertInto: managedContext)

        character.name = name
        character.hairColor = hairColor
        character.skinColor = skinColor
        character.eyeColor = eyeColor
        character.birthYear = birthYear
        character.gender = gender
        character.itemURL = url
        
        character.itemName = name
        character.category = "character"

        //Optional values
        if let heightString = json["height"] as? String, let height = Int16(heightString) {
            character.height = height
        } else {
            character.height = Int16(0)
        }

        if let massString = json["mass"] as? String, let mass = Int32(massString) {
            character.mass = mass
        } else {
            character.mass = Int32(0)
        }

        if let homeworldURL = json["homeworld"] as? String {
            character.homeworldURL = homeworldURL
        } else {
            character.homeworldURL = "w"
        }

        //print(character.description)
        
        do {
            try managedContext.save()
            characters[index] = character
            return character
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            print("Could not save character at index \(index)")
            return nil
        }
    }
    
    //One character is not downloading correctly: 17 Details not found
    func getCharacter(at index: Int, completion: @escaping (Character?) -> Void) {
        
        guard index < characters.count, index >= 0 else {
            completion(nil)
            return
        }
        
        //Check if data is in local cache
        if let character = characters[index] {
            completion(character)
        
        //If not, use NW request to download, then add to local cache, then return
        } else {
            //Download data with helper function
            if let url = URL(string: "https://swapi.co/api/people/\(index+1)/") {
                print("Data download URL is \(url)")
                dataService.fetchItem(at: url, completion: { (result) in
                    switch result {
                    case let .success(characterJSON):
                        //DispatchQueue.main.async {
                        //print(characterJSON)
                        if let character = self.addCharacter(characterJSON, to: index) {
                            completion(character)
                        } else {
                            print("JSON parsing error")
                            completion(nil)
                        }
                        //}
                    case let .failure(error):
                        print(error)
                    }
                })
            }
        }
        completion(nil)
    }
    
    //search: returned a filtered version of the data processed by CoreData filter
}
