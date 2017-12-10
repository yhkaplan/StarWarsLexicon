//
//  CharacterManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/23.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

class CharacterManager {
    let dataService = DataService()
    let filmManager = FilmManager()
    
    //MOC = Managed Object Context
    var moc: NSManagedObjectContext
    
    let sortByName = NSSortDescriptor(key: "itemName", ascending: true)

    private var characterURLCache = [String]()
    private var characterURLCount: Int { return characterURLCache.count }
    
    private var characters = [Character?]()
    var characterCount: Int { return characters.count }
    
    //Make sure to persists cell count as well!
    
    //init: loads from CoreData
    init() {
        //Set NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not set Managed Object Context")
        }
        //SWITCH THIS TO BACKGROUND CONTEXT?
        self.moc = appDelegate.persistentContainer.viewContext
        
        //Initialize characterURL data
        characterURLCache = APIService.sharedInstance.getURLStringCache(for: .character)
        
        //Make sure to persist cell count as well!
        
        //This just retreives existing data from Core Data stack if it exists
        //Consider using an array of tuples to make sure characters array and characterURLCache have same count...
        loadLocalCharacters()
        
        //If one or more character urls exists than saved character objects, start from the index of that difference
        //Say for example 2 characters were added and so character array only has items from 0-47,
        //then characterURLCount (50) - countDifference (2) would equal 48, which is exactly where we want to append to
        
        //Furthermore, in the case that there is no internet connection and characterURLCount is 0,
        //then 0 - 80 for example would be -80, so there would be no need to expand the character array
        let countDifference = characterURLCount - characterCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                characters.append(nil)
            }
        }
    }

    //This just retreives existing data from Core Data stack if it exists
    func loadLocalCharacters() {
        do {
            //Make array equal to fetched contents
            characters = try moc.fetch(Character.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    //Save new items func
    //This is needed for serializing the data when CoreData is integrated
    //Add new item func
    private func addCharacter(_ service: CharacterService, to index: Int) -> Character? {
        //JSON guards cleared so CoreData is available
        let character = Character(entity: Character.entity(), insertInto: moc)

        character.name = service.name
        character.hairColor = service.hairColor
        character.skinColor = service.skinColor
        character.eyeColor = service.eyeColor
        character.birthYear = service.birthYear
        character.gender = service.gender
        character.itemURL = service.url
        
        character.itemName = service.name
        character.category = "character"
        
        //Double check this. It likely needs improvement
        character.height = Int16(service.height) ?? Int16(-1)
        character.mass = Int32(service.mass) ?? Int32(-1)
        character.homeworldURL = service.homeworldURL
        
        // MARK: - Setting related films
        if let filmURLStrings = service.filmURLs {
            if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: filmURLStrings) {
                //Set value
                character.toFilm = relatedFilmSet
            }
        }
        //print(character.description)
        
        do {
            try moc.save()
            characters[index] = character
            return character
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            print("Could not save character at index \(index)")
            return nil
        }
    }
    
    // MARK: - Used for search
    
    func loadCharacters(with text: String) {
        //Create fetch request
        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
        
        //Add predicate with text string
        //C in CD means case insensitive, d means diacritic insensitive
        //"%K CONTAINS[cd] %@" = search for keypath containing input
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Character.itemName), text)
        
        fetchRequest.sortDescriptors = [sortByName]
        
        do {
            //Make array equal to fetched contents
            characters = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
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
            //This is to check if URL is equal to the url of any other items in the array before downloading
            //Double should theoretically never appear at this stage
            let urlString = characterURLCache[index]

            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            dataService.fetchItem(at: url, for: .character, completion: { (result) in
                switch result {
                
                //Success cases
                case let .success(characterService):
                    if let characterService = characterService as? CharacterService {
                        if let character = self.addCharacter(characterService, to: index) {
                            completion(character)
                            
                //Error cases
                        } else {
                            print("JSON parsing error")
                            completion(nil)
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            })
            completion(nil)
        }
    }
}
