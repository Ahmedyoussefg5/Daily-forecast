//
//  ListVM.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import RealmSwift

class ListVM: Object {
    @objc dynamic var id: String = ""
    var weather = List<WeatherVM>()
    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(items: [ListForecast], searchCityKeyWord: String) {
        self.init()
        self.id = searchCityKeyWord
        weather.append(objectsIn: items.map({ WeatherVM(weather: $0.weather) }))
    }
}

class WeatherVM: Object {
    @objc dynamic var weatherTitle = ""
    @objc dynamic var weatherDescription = ""

    convenience init(weather: [Weather]?) {
        self.init()
        weatherTitle = weather?.first?.main ?? ""
        weatherDescription = weather?.first?.weatherDescription ?? ""
    }
}
