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
    @IBOutlet weak var episodeLbl: UILabel!
    @IBOutlet weak var openingCrawlTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLbl.text = film.title
        episodeIDLbl.text = "\(film.episodeID)"
        episodeLbl.text = film.uid
        openingCrawlTextView.text = "Opening Crawl: " + film.openingCrawl
    }
    

}
