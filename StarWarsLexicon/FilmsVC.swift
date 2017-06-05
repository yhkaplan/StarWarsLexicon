//
//  FilmsVC.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class FilmsVC: UITableViewController {
    
    let dataService = DataService()
    let swObjectStore = SWObjectStore()
    
    var filmArray = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reload all theming code to separate file/class
        tableView.backgroundColor = UIColor.black
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        //tableView.delegate = self
        
        //All film data operations should be moved to item class that manages saving, deleting, etc
        
        dataService.fetchObjects { (result) -> Void in
            switch result {
            case let .filmSuccess(films):
                print("Retrieved \(films.count) films")
                if !films.isEmpty {
                    self.filmArray = films
                    self.tableView.reloadData()
                }
                print(films)
            case let .failure(error):
                print("Error with new process: \(error)")
            }
        }
    }
    
    func makeTestData() -> [Film] {
        var testArray = [Film]()
        for i in 0...3 {
            testArray.append(Film(title: "Film \(i)", episodeID: i, openingCrawl: "Once upon a time, in a galaxy far, far away"))
        }
        return testArray
    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("filmArray.count is \(filmArray.count)")
        return filmArray.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let film = filmArray[indexPath.row]
        cell.textLabel?.text = film.title
        cell.detailTextLabel?.text = "Test here"//Not working
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        return cell
    }
}
