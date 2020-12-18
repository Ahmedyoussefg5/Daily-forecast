//
//  URLRequestConveritble.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import Alamofire

protocol URLRequestConvertible: Alamofire.URLRequestConvertible {
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
}

extension URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.baseUrl)!.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
