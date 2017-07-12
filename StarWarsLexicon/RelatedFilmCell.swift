//
//  RelatedFilmCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/12.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class RelatedFilmCell: UICollectionViewCell {
    
    @IBOutlet weak var filmCoverImg: CircularImage!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configureCell(_ film: Film) {
        filmCoverImg.image = UIImage(named: "\(film.episodeID)")
        titleLbl.text = film.title
    }
}
