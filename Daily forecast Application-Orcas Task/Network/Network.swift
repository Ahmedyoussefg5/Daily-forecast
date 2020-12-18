//
//  Network.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Alamofire

typealias NetworkCompletion<T> = (AFResult<T>) -> ()

protocol NetworkProtocol {
    func request<T>(_ request: URLRequestConvertible, decodeTo type: T.Type, completionHandler: @escaping NetworkCompletion<T>) where T: Codable
    func upload<T>(_ request: URLRequestConvertible, data: [UploadData], decodedTo type: T.Type, completionHandler: @escaping NetworkCompletion<T>) where T: Codable
    func cancelAllRequests()
}

class Network {
    
    fileprivate let requestRetrierMiddleware = RequestRetrierMiddleware()
    fileprivate let requestAdapterMiddleware = RequestAdapterMiddleware()
    
    fileprivate lazy var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        let interceptor = Interceptor(adapter: requestAdapterMiddleware, retrier: requestRetrierMiddleware)
        let session = Session(configuration: configuration, interceptor: interceptor)
        return session
    }()
    
    fileprivate func process<T>(response: AFDataResponse<Any>, decodedTo type: T.Type) -> AFResult<T> where T: Codable {
        switch response.result {
            case .success:
                guard let data = response.data else {
                    return .failure(AFError.createURLRequestFailed(error: NSError.create(description: "Server Error.")))
                }
                
                #if DEBUG
                print("*************$$$$$$$$$*************")
                print(JSON(response.value ?? [:]))
                print("*************$$$$$$$$$*************")
                #endif
                
                do {
                    let data = try JSONDecoder.decodeFromData(type, data: data)
                    return .success(data)
                } catch {
                    #if DEBUG
                    debugPrint(error)
                    #endif
                    return .failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: NSError.create(description: "Server Error."))))
                }
                
            case .failure(let error):
                #if DEBUG
                debugPrint("#DEBUG#", error.localizedDescription)
                #endif
                
                if error.localizedDescription.contains("JSON") {
                    return .failure(.createURLRequestFailed(error: NSError.create(description: "Server Error.")))
                }
                return .failure(error)
        }
    }
    
    func cancelAllRequests() {
        session.cancelAllRequests()
    }
}

extension Network: NetworkProtocol {
    func request<T>(_ request: URLRequestConvertible, decodeTo type: T.Type, completionHandler: @escaping (AFResult<T>) -> ()) where T: Codable {
        #if DEBUG
        print(JSON(request.parameters ?? [:]))
        #endif
        session
            .request(request)
            .responseJSON {[weak self] response in
                guard let self = self else { return }
                completionHandler(self.process(response: response, decodedTo: type))
            }
    }
    
    func upload<T>(_ request: URLRequestConvertible, data: [UploadData], decodedTo type: T.Type, completionHandler: @escaping (AFResult<T>) -> ()) where T: Decodable, T: Encodable {
        #if DEBUG
        print(JSON(request.parameters ?? [:]))
        #endif
        session
            .upload(multipartFormData: { multipartFormData in
                data.forEach {
                    multipartFormData.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
                }
                
                for (key, value) in request.parameters ?? [:] {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }, with: request)
            .responseJSON {[weak self] response in
                guard let self = self else { return }
                completionHandler(self.process(response: response, decodedTo: type))
            }
            .responseString(completionHandler: { response in
                print(String(data: response.data ?? Data(), encoding: String.Encoding.utf16) ?? "")
            })
            .uploadProgress { (progress) in
                #if DEBUG
                print(String(format: "%.1f", progress.fractionCompleted * 100))
                #endif
            }
    }
}
