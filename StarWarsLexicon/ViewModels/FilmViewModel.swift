//
//  FilmViewModel.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/27.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol TableViewRefreshDelegate {
    func refreshTableView()
}

class FilmViewModel: NSObject {
    private let bag = DisposeBag()
    private var nextURLString: String? = "https://swapi.co/api/films/"
    private var films = [RealmFilm]()
    private var delegate: TableViewRefreshDelegate?
    
    enum FilmVMErrors: Error {
        case lastPage
    }
    
    //MARK: - Input
    //NetworkingService as singleton?
    var nwService: NetworkingService? //!
    //RealmModelManager (for saving to disk)
    
    //MARK: - Output
    //Films?
    //Page number
    
    //Add init here to initialize singleton(s) like ModelManager
//    init(nwService: NetworkingService? = nil) {
//        if let nwService = nwService {
//            self.nwService = nwService
//        } else {
//            self.nwService = NetworkingService()
//        }
//        super.init()
//    }
    
    func getFilmCount() -> Int {
        return films.count
    }
    
    func getFilm(at row: Int) -> RealmFilm {
        return films[row]
    }
    
    func set(delegate: TableViewRefreshDelegate) {
        self.delegate = delegate
        self.nwService = NetworkingService()
        //Refresh tableView
        let _ = getNextPageOfFilms()
            .subscribe(onNext: { _ in
                self.sortFilms()
                self.delegate?.refreshTableView()
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }
    
    private func sortFilms() {
        films.sort { (film1, film2) -> Bool in
            return film1.episodeID < film2.episodeID
        }
    }
    
    //private?
    //@discardableResult
    func getNextPageOfFilms() -> Observable<[RealmFilm]> {
        guard let nextURLString = nextURLString, let url = URL(string: nextURLString) else {
            //Last page
            return Observable<[RealmFilm]>.error(FilmVMErrors.lastPage)
        }
        
        //Change code below to be optional
        return nwService!.fetchItemsAndNextPage(at: url, for: .film)
            //The side effects below should be moved out of map
            .map { filmList in
                self.nextURLString = filmList.nextPage
                self.films.append(contentsOf: filmList.films)
                //Call sortFilm method
                //Add films to ModelManager so it can save them to disk
                return filmList.films
            }
    }
}
