//
//  VehiclesViewModel.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation
import Combine
import UIKit

class VehiclesViewModel {
    
    @Published var vehiclesModel = Vehicles(data: [], included: [])
    //@Published private(set) var image:UIImage?
    
    private var subscription: Set<AnyCancellable> = []

    func fetch(searchTerm:String) {
        NetworkManager.getData(searchTerm: searchTerm)
            .replaceError(with: vehiclesModel)
            .sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    break
                case .failure(let error):
                print(error)
                }
            }, receiveValue: {[weak self] vehicles in
                guard let self = self else {return}
                self.vehiclesModel = vehicles
            }
        )
        .store(in: &subscription)
    }

//    func loadImage(index: Int, completion: @escaping (UIImage?) -> Void){
//        DispatchQueue.global(qos: .utility).async {
//            var urlString: String?
//            let id = self.vehiclesModel.data[index].relationships?.primaryImage?.data.id
//            let includedArray = self.vehiclesModel.included
//            let includedDict = Dictionary(uniqueKeysWithValues: includedArray.map{($0.id, $0.attributes.url)})
//            if let id = id, let url = includedDict[id] {
//                urlString = url
//            }
//            if let urlString = urlString, let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
//                let image = UIImage(data: data)
//                completion(image)
//            }
//        }
//
//    }
    func getUrl(at indexPath: IndexPath ) -> URL? {

        var urlString: String?
        let id = vehiclesModel.data[indexPath.item].relationships?.primaryImage?.data.id
        let includedArray = vehiclesModel.included
        let includedDict = Dictionary(uniqueKeysWithValues: includedArray.map{($0.id, $0.attributes.url)})
        if let id = id, let url = includedDict[id] {
            urlString = url
        }
        if let urlString = urlString {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
}

