//
//  CharacterDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/30.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CharacterDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var character: Character!
    private var relatedFilmArray = [Film]()
    private var homeworld: Planet?
    
    let dataService = DataService()
    
    @IBOutlet weak var filmCollectionView: UICollectionView!
    @IBOutlet weak var homeworldButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var homeworldLbl: UILabel!
    @IBOutlet weak var birthYearLbl: UILabel!
    @IBOutlet weak var eyeColorLbl: UILabel!
    @IBOutlet weak var skinColorLbl: UILabel!
    @IBOutlet weak var hairColorLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmCollectionView.dataSource = self
        filmCollectionView.delegate = self
        
        homeworldButton.isEnabled = false
        let nilLabel = "Unknown"
        
        if let character = character {
            self.nameLbl.text = character.name.capitalized
            self.birthYearLbl.text = character.birthYear.capitalized
            self.eyeColorLbl.text = character.eyeColor.capitalized
            self.skinColorLbl.text = character.skinColor.capitalized
            self.hairColorLbl.text = character.hairColor.capitalized
            self.genderLbl.text = character.gender.capitalized
//            if let height = character.height {
//                heightLbl.text = "\(height)"
//            } else {
//                heightLbl.text = nilLabel
//            }
//            if let mass = character.mass {
//                massLbl.text = "\(mass)"
//            } else {
//                massLbl.text = nilLabel
//            }
//            
//            initializeHomeworld()
//            initializeRelatedFilms()
        }
    }
    
    @IBAction func showHomeworld(_ sender: UIButton) {
        if let homeworld = homeworld {
            performSegue(withIdentifier: "showHomeworld", sender: homeworld)
        }
    }
    
//    func initializeHomeworld() {
//        if let homeworldURL = character.homeworldURL {
//            dataService.fetchHomeworld(from: homeworldURL, completion: { (result) in
//                switch result {
//                case let .success(homeworld):
//                    DispatchQueue.main.async {
//                        print("Homeworld is \(homeworld)")
//                        self.homeworld = homeworld
//                        //update label and show link UI
//                        self.homeworldLbl.text = homeworld.name + "➡︎"
//                        //activate invisible button link
//                        self.homeworldButton.isEnabled = true
//                    }
//                case let .failure(error):
//                    print("Error: \(error)")
//                    break
//                }
//            })
//        } 
//    }
    
//    func initializeRelatedFilms() {
//        //guard for 1. empty url arrays and 2. urls that are nil
//        if character.filmURLArray.isEmpty {
//            //Display message saying not found in films
//        } else {
//            for filmURL in character.filmURLArray {
//                if let filmURL = filmURL {
//                    dataService.fetchRelatedFilm(from: filmURL, completion: { (result) in
//                        switch result {
//                        case let .success(relatedFilm):
//                            DispatchQueue.main.async {
//                                print("Retrieved \(relatedFilm)")
//                                self.relatedFilmArray.append(relatedFilm)
//                                self.filmCollectionView.reloadData()
//                            }
//                        case let .failure(error):
//                            print("Error: \(error)")
//                            break
//                        }
//                    })
//                }
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRelatedFilm"?:
            if let filmDetailVC = segue.destination as? FilmDetailVC {
                if let relatedFilm = sender as? Film {
                    filmDetailVC.film = relatedFilm
                }
            }
        case "showHomeworld"?:
            if let planetDetailVC = segue.destination as? PlanetDetailVC {
                if let homeworld = sender as? Planet {
                    planetDetailVC.detailPlanet = homeworld
                }
            }
        //ADD HERE FOR OTHER SEGUES
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilm = relatedFilmArray[indexPath.row]
        performSegue(withIdentifier: "showRelatedFilm", sender: selectedFilm)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.0, height: 85.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = filmCollectionView.dequeueReusableCell(withReuseIdentifier: "RelatedFilmCell", for: indexPath) as? RelatedFilmCell {
            cell.configureCell(relatedFilmArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedFilmArray.count
    }
}
