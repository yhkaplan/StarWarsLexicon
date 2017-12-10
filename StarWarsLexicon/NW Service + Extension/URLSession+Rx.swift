//
//  URLSession+Rx.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/27.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RxSwift

/*
This is an RxExtension to URLSession so I don't have to rely on external frameworks like Alamofire, etc.
 Made heavy reference to Chapter 17 of the book "RxSwift: Reactive Programming with Swift"
*/

//Persist this cache w/ Realm?
private var internalCache = [String: Data]()

extension ObservableType where E == (HTTPURLResponse, Data) {
    func cache() -> Observable<E> {
        return self.do(onNext: {(response, data) in
            if let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode {
                internalCache[url] = data
            }
        })
    }
}

public enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case requestFailed(response: HTTPURLResponse, data: Data?)
}

extension Reactive where Base: URLSession {
    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { observer in
            let task = self.base.dataTask(with: request) { (data, response, error) in
                //Handles common error cases
                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxURLSessionError.unknown))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxURLSessionError.invalidResponse(response: response)))
                    return
                }
                
                observer.on(.next((httpResponse, data))) //Does this really need to be a tuple with the extra paratheses?
                observer.on(.completed)
            }
            task.resume()
            
            //Cancels task to prevent waste of resources
            return Disposables.create(with: task.cancel)
        }
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        if let url = request.url?.absoluteString, let data = internalCache[url] {
            return Observable.just(data)
        }
        
        return response(request: request).cache().map { (response, data) -> Data in
            if 200 ..< 300 ~= response.statusCode {
                return data
            } else {
                throw RxURLSessionError.requestFailed(response: response, data: data)
            }
        }
    }
}
