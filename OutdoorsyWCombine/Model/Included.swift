//
//  Included.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation
struct Included: Codable, Hashable {
    
    var id: String
    var attributes: IncludedAttribute
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Included, rhs: Included) -> Bool {
        lhs.id == rhs.id
    }
}

struct IncludedAttribute: Codable {
    var url: String
}
 
