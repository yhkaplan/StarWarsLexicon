//
//  FilmCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmCell: UITableViewCell {

    //Reference RainyShinyCloudy app!!
    
    //IBOutlets for title, movie number, photo
    @IBOutlet weak var filmCoverImg: UIImageView!
    @IBOutlet weak var filmTitleLbl: UILabel!
    @IBOutlet weak var filmNumberLbl: UILabel!
    
    func configureCell(film: Film) {
        
        //Set arrows to visible
        //disclosure indicator visible
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        filmTitleLbl.text = film.title
        filmNumberLbl.text = "Film \(film.episodeID)"
        //Image file
    }
}
