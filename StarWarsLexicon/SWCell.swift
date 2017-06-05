//
//  SWCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class SWCell: UICollectionViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    
    var film: Film!
    
    func configureCell (_ film: Film) {
        //make this accept a generic, then respond with switch to determine the type and configure appropriately
        self.film = film
        
        textLbl.text = self.film.title
    }
    
}
