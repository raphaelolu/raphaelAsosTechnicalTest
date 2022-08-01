//
//  APIError.swift
//  raphTechnicalTest
//
//  Created by raphael olumofe on 31/07/2022.
//

import Foundation

enum APIError:Error,CustomStringConvertible {

    case badUrl
    case badResponse(statusCode:Int)
    case URL(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String{
        switch self {
        case .badUrl, .parsing, .unknown:
            return "Sorry something went wrong"
        case .badResponse(_):
            return "Sorry, the connection to the server failed"
        case .URL(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    var description: String{
        switch self{
        case .unknown: return "unknown error"
        case .badUrl: return "invlaid URL"
        case .URL(let error):
            return error?.localizedDescription ?? "url sessions error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        }
    }
}
