//
//  Repository.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import Alamofire
import RealmSwift

protocol HomeRepositoryProtocol {
    func searchForForcastFor(city name: String, completionHandler: @escaping (AFResult<ForecastModel>) -> ())
    func searchForForcastForInLocalStorage(city name: String, completionHandler: @escaping (ListVM?) -> ())
    func saveInLocalDataBase(data: ListVM)
}

class HomeRepository: HomeRepositoryProtocol {
    
    private var network: NetworkProtocol
    private let localStorage: LocalStorageProtocol
    
    required init(network: NetworkProtocol, localStorage: LocalStorageProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    func searchForForcastFor(city name: String, completionHandler: @escaping (AFResult<ForecastModel>) -> ()) {
        network.request(CitySearchRouter.search(cityName: name), decodeTo: ForecastModel.self, completionHandler: completionHandler)
    }
    
    func searchForForcastForInLocalStorage(city name: String, completionHandler: @escaping (ListVM?) -> ()) {
        let result = localStorage.findByPrimaryKey(name)
        completionHandler(result)
    }
    
    func saveInLocalDataBase(data: ListVM) {
        localStorage.save(data)
    }
}
