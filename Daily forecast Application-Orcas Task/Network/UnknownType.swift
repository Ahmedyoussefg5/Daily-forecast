//
//  UnknownType.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation

enum UnknownType<F: Codable, S: Codable>: Codable {
    
    case firstValue(F)
    case secoundValue(S)
    
    var value: String? {
        switch self {
            case .secoundValue(let val):
                return "\(val)"
            case .firstValue(let val):
                return val as? String
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(F.self) {
            self = .firstValue(value)
            return
        }
        if let value = try? container.decode(S.self) {
            self = .secoundValue(value)
            return
        }
        throw DecodingError.typeMismatch(UnknownType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .secoundValue(let x):
                try container.encode(x)
            case .firstValue(let x):
                try container.encode(x)
        }
    }
}
