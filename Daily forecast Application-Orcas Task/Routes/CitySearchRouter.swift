//
//  CitySearcRouter.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Alamofire

enum CitySearchRouter: URLRequestConvertible {
    
    case search(cityName: String)
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var parameters: [String: Any]? {
        switch self {
            case .search(let cityName):
                return [
                    "q": cityName,
                    "cnt": Int.random(in: 3...13),
                    "appid": Constants.openWeatherAPIKey
                ]
        }
    }
    
    var path: String {
        switch self {
            case .search:
                return "forecast/daily"
        }
    }
}
