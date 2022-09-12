//
//  VehicleData.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation

struct VehicleData: Codable, Hashable{

    var id: String
    var type: String
    var attributes: Attribute?
    var relationships: Relationship?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: VehicleData, rhs: VehicleData) -> Bool {
        lhs.id == rhs.id
    }
}
struct Attribute: Codable {
    var name: String
}
struct Relationship: Codable {
    var primaryImage: PrimaryImage?
    
    enum CodingKeys: String, CodingKey {
        case primaryImage = "primary_image"
    }
}
struct PrimaryImage: Codable {
    var data: ImageData
}
struct ImageData: Codable {
    var id: String
    var type: String
}
