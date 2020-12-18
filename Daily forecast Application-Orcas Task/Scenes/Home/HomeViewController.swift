//
//  ViewController.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import UIKit

protocol HomeViewProtocol: BaseViewProtocol {
    func dataTaskSuccess()
    func showAlert(error: String)
    func showAlertWithRetry(error: String)
}

class HomeViewController: UITableViewController {
    
    // MARK:- UITableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        presenter.config(cell, at: indexPath.row)        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getForecastListCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private var presenter: HomePresenterProtocol!
    
    private let searchBar = UISearchBar()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // Prevent the creation of the ViewController outside of the "create" method"
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoader()
        setupTableView()
        setupAddSearchBarToNavigationItem()
    }
    
    private func setupTableView() {
        tableView.register(ForecastCell.self, forCellReuseIdentifier: "ForecastCell")
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupAddSearchBarToNavigationItem() {
        searchBar.placeholder = "Search For City .."
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupLoader() {
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func searchForCityForecast() {
        let searchText = searchBar.text
        presenter.searchForForcast(city: searchText)
    }
}

extension HomeViewController: HomeViewProtocol {
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func dataTaskSuccess() {
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func showAlertWithRetry(error: String) {
        let alert = getAlertWithCloseButton(title: "Error", message: error)
        alert.addAction(.init(title: "Retry", style: .default, handler: { _ in
            self.searchForCityForecast()
        }))
        present(alert, animated: true)
    }
    
    func showAlert(error: String) {
        let alert = getAlertWithCloseButton(title: "Error", message: error)
        present(alert, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForCityForecast()
    }
}

extension HomeViewController {
    // Create class and its dependcies
    class func create() -> HomeViewController {
        let network = Network()
        let localStorage = LocalStorage()
        let authRepository = HomeRepository(network: network, localStorage: localStorage)
        let view = HomeViewController()
        let presenter = HomePresenter(view: view, repository: authRepository)
        view.presenter = presenter
        return view
    }
}
