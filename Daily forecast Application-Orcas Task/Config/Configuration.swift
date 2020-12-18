//
//  Configuration.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation

enum Configuration {
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
            case let value as T:
                return value
            case let string as String:
                guard let value = T(string) else { fallthrough }
                return value
            default:
                throw Error.invalidValue
        }
    }
}

struct Constants {
    static let baseUrl = "http://api.openweathermap.org/data/2.5/"
    static var responseValid = "success"
    static var openWeatherAPIKey = "886705b4c1182eb1c69f28eb8c520e20"
}
