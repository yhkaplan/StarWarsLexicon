//
//  FilmVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var filmVM: FilmViewModel!
    
    private let filmSegueName = "showFilm"
    private let filmCellReuseIdentifier = "FilmCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        filmVM.set(delegate: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Move this segue action to a seperate scene coordinator
        switch segue.identifier {
        case filmSegueName?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let film = filmVM.getFilm(at: row)
                let filmDetailVC = segue.destination as! FilmDetailVC
                //filmDetailVC.film = film Use DI to set filmDetailView as selected film
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

extension FilmVC: TableViewRefreshDelegate {
    func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FilmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.0
    }
}

extension FilmVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmVM.getFilmCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Refactor for loading cells logic
        if let cell = tableView.dequeueReusableCell(withIdentifier: filmCellReuseIdentifier, for: indexPath) as? FilmCell {
            let film = filmVM.getFilm(at: indexPath.row)
            cell.configureCell(film: film)
            return cell
        } else {
            return FilmCell()
        }
    }
}
