//
//  FilmDetailVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/25.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmDetailVC: UIViewController {

    var film: Film!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var episodeIDLbl: UILabel!
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    
    @IBOutlet weak var openingCrawlTextView: UITextView!
    @IBOutlet weak var filmCoverImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLbl.text = film.title
        episodeIDLbl.text = "\(film.episodeID)"
        directorLbl.text = film.director
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateStyle = .medium
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        let releaseDateString = formatter.string(from: film.releaseDate)
        releaseDateLbl.text = releaseDateString
        
        openingCrawlTextView.text = "Opening Crawl: \n" + film.openingCrawl
        filmCoverImageView.image = UIImage(named: "\(film.episodeID)")
    }
    

}
