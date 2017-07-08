//
//  CharacterDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/30.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CharacterDetailVC: UIViewController {

    var character: Character!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var birthYearLbl: UILabel!
    @IBOutlet weak var eyeColorLbl: UILabel!
    @IBOutlet weak var skinColorLbl: UILabel!
    @IBOutlet weak var hairColorLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nilLabel = "Unknown"
        
        if let character = character {
            self.nameLbl.text = character.name
            self.birthYearLbl.text = character.birthYear
            self.eyeColorLbl.text = character.eyeColor
            self.skinColorLbl.text = character.skinColor
            self.hairColorLbl.text = character.hairColor
            self.genderLbl.text = character.gender
            if let height = character.height {
                heightLbl.text = "\(height)"
            } else {
                heightLbl.text = nilLabel
            }
            if let mass = character.mass {
                massLbl.text = "\(mass)"
            } else {
                massLbl.text = nilLabel
            }
        }
    }

}
