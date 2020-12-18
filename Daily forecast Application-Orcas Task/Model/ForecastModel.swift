//
//  ForecastModel.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation

// MARK: - Object
struct ForecastModel: BaseCodable {
    var cod: String
    let city: City?
    let message: UnknownType<String, Double>?
    let list: [ListForecast]?
}

// MARK: - City
struct City: Codable {
    let name: String?
    let id: Int?
    let country: String?
}

// MARK: - List
struct ListForecast: Codable {
    let temp: Temp?
    let weather: [Weather]?

    enum CodingKeys: String, CodingKey {
        case temp, weather
    }
}

// MARK: - Temp
struct Temp: Codable {
    let day, morn, min, night: Double?
    let eve, max: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let icon, weatherDescription, main: String?

    enum CodingKeys: String, CodingKey {
        case id, icon
        case weatherDescription = "description"
        case main
    }
}
