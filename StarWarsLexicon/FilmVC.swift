//
//  FilmVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let dataService = DataService()
    var url: URL? = URL(string: "https://swapi.co/api/films/")
    var selectedIndexPath = IndexPath()
    
    private var filmArray = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupStatusBarAndTableView()
        initializeFilms()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("selectedIndexPath = \(selectedIndexPath)")
        if !selectedIndexPath.isEmpty {
            tableView.cellForRow(at: selectedIndexPath)?.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        }
    }
    
    func setupStatusBarAndTableView() {
        //Reload all theming code to separate file/class
        
        //widen! navigationItem.titleView?.leadingAnchor
        tableView.isHidden = true
    }

    func initializeFilms() {
        guard let url = url else {
            //Throw error
            return
        }
        
        self.dataService.fetchObjects(category: .film, url: url) { (result) -> Void in
            switch result {
            case let .filmSuccess(films, nextURL):
                DispatchQueue.main.async {
                    if !films.isEmpty {
                        self.filmArray.append(contentsOf: films)
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                    
                    if let nextURL = nextURL {
                        self.url = nextURL
                        self.initializeFilms()
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
                break
            default:
                print("Wrong type read")
                break
            }
        }
    }
    
//    func organizeFilms() {
//        var newArray = [Film]()
//        
//        for film in filmArray.enumerated() {
//            newArray.insert(film, at: film.episodeID-1)
//        }
//        filmArray = newArray
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFilm"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let film = filmArray[row]
                let filmDetailVC = segue.destination as! FilmDetailVC
                filmDetailVC.film = film
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.darkGray
        selectedIndexPath = indexPath
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //print("filmArray.count is \(filmArray.count)")
        return filmArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as? FilmCell {
            let film = filmArray[indexPath.row]
            cell.configureCell(film: film)
            return cell
        } else {
            return FilmCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.0
    }
}
