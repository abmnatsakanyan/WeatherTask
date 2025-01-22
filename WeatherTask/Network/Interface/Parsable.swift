//
//  Parsable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol Parsable {
    func parse<T: Decodable>(from data: Data) throws -> T
}
