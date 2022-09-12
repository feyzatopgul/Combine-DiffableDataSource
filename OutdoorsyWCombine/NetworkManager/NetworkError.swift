//
//  NetworkError.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import Foundation

enum NetworkError:Error {
    case statusCode
    case decoding
    case other(Error)
    static func map(_ error: Error) -> NetworkError {
        return (error as? NetworkError) ?? .other(error)
    }
}
