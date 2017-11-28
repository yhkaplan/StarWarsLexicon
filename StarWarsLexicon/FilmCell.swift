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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = UITableViewCellAccessoryType.none
        hideAll(true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = UITableViewCellAccessoryType.none
        hideAll(true)
    }
    
    private func hideAll(_ status: Bool) {
        filmCoverImg.isHidden = status
        filmTitleLbl.isHidden = status
        filmNumberLbl.isHidden = status
        
    }
    
    func configureCell(film: RealmFilm) {
        activityIndicator.stopAnimating()
        hideAll(false)
        //Set arrows to visible
        //disclosure indicator visible
        self.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        filmTitleLbl.text = film.title
        filmNumberLbl.text = "Film \(film.episodeID)"
        //Image file
        filmCoverImg.image = UIImage(named: "\(film.episodeID)")
    }
}
