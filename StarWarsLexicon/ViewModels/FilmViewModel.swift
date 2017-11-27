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

class FilmViewModel {
    private let bag = DisposeBag()
    private var nextURLString: String? = "https://swapi.co/api/films/"
    private var films = [RealmFilm]()
    
    enum FilmVMErrors: Error {
        case lastPage
    }
    
    //MARK: - Input
    //NetworkingService as singleton?
    let nwService: NetworkingService!
    //RealmModelManager (for saving to disk)
    
    //MARK: - Output
    //Films?
    //Page number
    
    //Add init here to initialize singleton(s) like ModelManager
    init(nwService: NetworkingService) {
        self.nwService = nwService
        getNextPageOfFilms()
            .do(onNext: { _ in self.tableViewRefreshDelegate() })
            //dispose??
    }
    
    func getFilmCount() -> Int {
        return films.count
    }
    
    func getFilm(at row: Int) -> RealmFilm {
        return films[row]
    }
    
    private func tableViewRefreshDelegate() {
        //Refresh tableView
    }
    
    //private?
    //@discardableResult
    func getNextPageOfFilms() -> Observable<[RealmFilm]> {
        guard let nextURLString = nextURLString, let url = URL(string: nextURLString) else {
            //Last page
            return Observable<[RealmFilm]>.error(FilmVMErrors.lastPage)
        }
        
        return nwService.fetchItemsAndNextPage(at: url, for: .film)
            .map { filmList in
                self.nextURLString = filmList.nextPage
                self.films.append(contentsOf: filmList.films)
                //Add films to ModelManager so it can save them to disk
                return filmList.films
            }
    }
}
