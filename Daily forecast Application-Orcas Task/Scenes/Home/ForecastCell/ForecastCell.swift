//
//  ForecastCell.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import UIKit

protocol ForecastCellProtocol {
    func displayTitle(with text: String)
    func displayDetails(with text: String)
}

class ForecastCell: UITableViewCell, ForecastCellProtocol {
    func displayTitle(with text: String) {
        textLabel?.text = text
    }
    
    func displayDetails(with text: String) {
        detailTextLabel?.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
