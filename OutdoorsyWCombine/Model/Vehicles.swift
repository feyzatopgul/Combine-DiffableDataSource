//
//  Vehicles.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation

struct Vehicles: Codable, Hashable {
    var data: [VehicleData]
    var included: [Included]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(included)
    }
    static func == (lhs: Vehicles, rhs: Vehicles) -> Bool {
        lhs.data == rhs.data && lhs.included == rhs.included
    }
}

