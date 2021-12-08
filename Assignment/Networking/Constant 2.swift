//
//  Constant.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import Foundation
import SystemConfiguration


enum AppMessages: String {
    case httpRequestFailed = "Http request is failed"
    case httpRequestTimeOut = "Http request time is over"
    case noInternet = "No internet connection available"
    case emptyMobileNumber = "please enter valid mobile number"
    case invalidMobileNumber  = "invalid Mobile Number"
    case wishNotificationName = "updateWish"
    case cartUpdateAdd = "addToCard"
}

// custom error
public enum APIError:Error {
     case failedRequest(String?)
}

// hTTPS methods type
public enum HttpsMethod {
    case Post
    case Get
    case Put
    case Delate
    
    var localization:String{
        switch self {
        case .Post: return "POST"
        case .Get: return "GET"
        case .Put: return "PUT"
        case .Delate: return "Delete"
            
        }
        
    }
}

// generics result type
public enum Result<T, U> where U:Error {
    case success(T)
    case failure(U)
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
