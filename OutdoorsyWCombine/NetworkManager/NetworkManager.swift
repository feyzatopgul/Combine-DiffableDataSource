//
//  NetworkManager.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation
import Combine

class NetworkManager {
    //private var subscriber = Set<AnyCancellable>()
 
    static func getData(searchTerm:String) -> AnyPublisher<Vehicles, NetworkError> {
        let url = URL(string: "https://search.outdoorsy.co/rentals?filter[keywords]=\(searchTerm)")!
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                guard
                let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw NetworkError.statusCode
                }
                return response.data
            }
            .decode(type: Vehicles.self, decoder: JSONDecoder())
            .mapError {  NetworkError.map($0)}
            .eraseToAnyPublisher()
    }
    
//    static func getImage(url: URL) -> AnyPublisher<Data, NetworkError> {
//        let urlRequest = URLRequest(url: url)
//        return URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .tryMap { response in
//                guard
//                let httpURLResponse = response.response as? HTTPURLResponse,
//                    httpURLResponse.statusCode == 200
//                else {
//                    throw NetworkError.statusCode
//                }
//                return response.data
//            }
//            .mapError{NetworkError.map($0)}
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
}
