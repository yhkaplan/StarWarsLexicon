//
//  FilmVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmVC: UIViewController, FilmVCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let dataService = DataService()
    var filmManager: FilmManager?
    var selectedIndexPath = IndexPath()
    
    var rowCount = 7//0
    let filmSegueName = "showFilm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        filmManager = FilmManager(filmVCDelegate: self)
        filmManager?.getFilmCount()
    }
    
    func updateCount(_ filmCount: Int) {
        rowCount = filmCount
        tableView.reloadData()
    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        print("selectedIndexPath = \(selectedIndexPath)")
//        if !selectedIndexPath.isEmpty {
//            tableView.cellForRow(at: selectedIndexPath)?.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
//        }
//    }
//    
//    func setupStatusBarAndTableView() {
//        //Reload all theming code to separate file/class
//        
//        //widen! navigationItem.titleView?.leadingAnchor
//        tableView.isHidden = true
//    }
//

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case filmSegueName?:
            if let row = tableView.indexPathForSelectedRow?.row {
                filmManager?.getFilm(at: row, completion: { (film) in
                    if let film = film {
                        DispatchQueue.main.async {
                            let filmDetailVC = segue.destination as! FilmDetailVC
                            filmDetailVC.film = film
                        }
                    }
                })
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}

extension FilmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.darkGray
        selectedIndexPath = indexPath
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.0
    }
}

extension FilmVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as? FilmCell {
            filmManager?.getFilm(at: indexPath.row, completion: { (film) in
                if let film = film {
                    DispatchQueue.main.async {
                        cell.configureCell(film: film)
                        //return cell
                    }
                }
            })
            return cell
        } else {
            return FilmCell()
        }
    }
}
