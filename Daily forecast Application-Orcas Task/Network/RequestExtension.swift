//
//  RequestExtension.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("====================******************===================")
        debugPrint(self)
        debugPrint("====================******************===================")
        #endif
        return self
    }
}
