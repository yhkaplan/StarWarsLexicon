////
////  APIService.swift
////  StarWarsLexicon
////
////  Created by Joshua Kaplan on 2017/07/31.
////  Copyright © 2017年 Joshua Kaplan. All rights reserved.
////
//
//import Foundation
//
//class APIService {
//    func initializeCharacter(from json: [String : Any]) -> Character? {
//        guard let name = json["name"] as? String else {
//            print("Parsing error with character name")
//            return nil
//        }
//
//        guard let hairColor = json["hair_color"] as? String else {
//            print("Parsing error with character hair color")
//            return nil
//        }
//
//        guard let skinColor = json["skin_color"] as? String else {
//            print("Parsing error with character skin color")
//            return nil
//        }
//
//        guard let eyeColor = json["eye_color"] as? String else {
//            print("Parsing error with character eye color")
//            return nil
//        }
//
//        guard let birthYear = json["birth_year"] as? String else {
//            print("Parsing error with character birth year")
//            return nil
//        }
//
//        guard let gender = json["gender"] as? String else {
//            print("Parsing error with character gender")
//            return nil
//        }
//
//        guard let url = json["url"] as? String else {
//            print("Parsing error with url")
//            return nil
//        }
//
//        self.name = jsonName
//        self.hairColor = hairColor
//        self.skinColor = skinColor
//        self.eyeColor = eyeColor
//        self.birthYear = birthYear
//        self.gender = gender
//        self.itemURL = url
//
//        //Optional values
//        if let heightString = json["height"] as? String, let height = Int16(heightString) {
//            self.height = height
//        } else {
//            self.height = 0
//        }
//
//        if let massString = json["mass"] as? String, let mass = Int32(massString) {
//            self.mass = mass
//        } else {
//            self.mass = 0
//        }
//
//        if let homeworldURL = json["homeworld"] as? String {
//            self.homeworldURL = homeworldURL
//        }
//
//
//        
//    }
//}
