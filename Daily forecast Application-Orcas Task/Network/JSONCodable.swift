//
//  JSONCodable+.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation

extension JSONDecoder {
    static func decodeFromData<U: Codable>(_ model: U.Type, data: Data) throws -> U {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(U.self, from: data)
        } catch {
            debugPrint(error)
            throw error
        }
    }
}
