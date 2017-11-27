//
//  NetworkingService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/27.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RxSwift

public enum SWAPICategory {
    case film
    case character
    case starship
    case planet
    case vehicle
}

class NetworkingService {
    private enum NetworkError: Error {
        case noData
        case jsonParsingError
    }
    
    func fetchItemsAndNextPage(at url: URL, for category: SWAPICategory) -> Observable<FilmList> { //To change from FilmList
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data in
                //JSON decoder
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    switch category {
                    case .film:
                        return try decoder.decode(FilmList.self, from: data)
                    //Expand to switch to cover over data types
                    default:
                        throw NetworkError.jsonParsingError
                    }
                } catch let error {
                    throw error
                }
            }
    }
}
