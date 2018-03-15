//
//  Request.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

typealias Parameters = [String: Any]

enum Method: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

protocol Model {
}

enum Priority: Int16 {
    case low, medium, high
}

protocol Request {
    associatedtype Model
    
    var path: String { get }
    var method: Method { get }
    var body: Data? { get }
    var queryParameters: [String: String]? { get }
    static var name: String { get }
    
    func asURLRequest(baseUrl: String) -> URLRequest
    func map(from data: Data) -> Model?
    
}

extension Request {
    var method: Method { return .get }
    var body: Data? { return nil }
    var queryParameters: [String: String]? { return nil }
    static var name: String {
        return String(describing: Self.self)
    }
    
    func map(from data: Data) -> Model? {
        return nil
    }
    
    func asURLRequest(baseUrl: String) -> URLRequest {
        let fullPath = baseUrl.appending(path)
        var urlComponents = URLComponents(string: fullPath)
        urlComponents?.queryItems = (queryParameters ?? [:]).map { URLQueryItem(name: $0, value: $1) }
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpBody = body
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

protocol DecodableResultRequest: Request where Model: Decodable {
    
}

extension DecodableResultRequest {
    func map(from data: Data) -> Model? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Model.self, from: data)
    }
}
