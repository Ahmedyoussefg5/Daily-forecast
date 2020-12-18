//
//  HomePresenter.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import Alamofire

protocol HomePresenterProtocol {
    func searchForForcast(city name: String?)
    func getForecastListCount() -> Int
    func config(_ cell: ForecastCellProtocol, at index: Int)
}

class HomePresenter {
    
    weak var view: HomeViewProtocol?
    private let homeRepository: HomeRepositoryProtocol
    
    private var forecastList: ListVM?
    
    init(view: HomeViewProtocol, repository: HomeRepositoryProtocol) {
        self.view = view
        self.homeRepository = repository
    }
    
    private func handleResponse(_ result: AFResult<ForecastModel>, searchCityKeyWord: String) {
        view?.hideActivityIndicator()
        switch result {
            case .success(let data):
                if data.isSuccess {
                    didGetDataSuccess(data: .init(items: data.list ?? [], searchCityKeyWord: searchCityKeyWord))
                } else {
                    view?.showAlert(error: data.message?.value ?? "Error")
                }
            case .failure(let error):
                searchInLocalStorage(city: searchCityKeyWord, error: error)
        }
    }
    
    private func validate(searchText: String?) -> Bool {
        return (searchText ?? "").count > 0
    }
    
    private func didGetDataSuccess(data: ListVM, saveDataToLocal: Bool = true) {
        if saveDataToLocal {
            homeRepository.saveInLocalDataBase(data: data)
        }
        forecastList = data
        view?.dataTaskSuccess()
    }
}

extension HomePresenter: HomePresenterProtocol {
    func config(_ cell: ForecastCellProtocol, at index: Int) {
        cell.displayTitle(with: forecastList?.weather[index].weatherTitle ?? "")
        cell.displayDetails(with: forecastList?.weather[index].weatherDescription ?? "")
    }
    
    func getForecastListCount() -> Int {
        return forecastList?.weather.count ?? 0
    }
    
    func searchForForcast(city name: String?) {
        guard validate(searchText: name) else { return }
        view?.showActivityIndicator()
        homeRepository.searchForForcastFor(city: name!) {[weak self] result in
            self?.handleResponse(result, searchCityKeyWord: name!)
        }
    }
    
    func searchInLocalStorage(city name: String?, error: AFError) {
        view?.showActivityIndicator()
        homeRepository.searchForForcastForInLocalStorage(city: name!) {[weak self] result in
            self?.view?.hideActivityIndicator()
            if let result = result {
                self?.didGetDataSuccess(data: result, saveDataToLocal: false)
            } else {
                self?.view?.showAlertWithRetry(error: error.localizedDescription)
            }
        }
    }
}
