//
//  BaseCodable.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation

protocol BaseCodable: Codable {
    var isSuccess: Bool { get }
    var cod: String { get }
    var message: UnknownType<String, Double>? { get }
}

extension BaseCodable {
    var isSuccess: Bool {
        return cod == "200"
    }
}

struct BaseModel: BaseCodable {
    var cod: String
    var message: UnknownType<String, Double>?
}
