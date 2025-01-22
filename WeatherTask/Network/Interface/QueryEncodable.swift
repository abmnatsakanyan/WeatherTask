//
//  QueryEncodable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol QueryEncodable {
    var parameters: [String: String] { get }

    func encode(urlRequest: inout URLRequest) throws
}
