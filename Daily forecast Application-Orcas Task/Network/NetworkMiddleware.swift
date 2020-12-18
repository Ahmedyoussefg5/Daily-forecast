//
//  NetworkMiddleware.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import Alamofire

class RequestAdapterMiddleware: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("en", forHTTPHeaderField: "lang")
        urlRequest.setValue("os", forHTTPHeaderField: "ios")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        #if DEBUG
        debugPrint("====================******************===================")
        // let _ = dump(urlRequest)
        print(urlRequest)
        print(urlRequest.allHTTPHeaderFields!)
        print(urlRequest.method!)
        debugPrint("====================******************===================")
        #endif
        
        completion(.success(urlRequest))
    }
}
