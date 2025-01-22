//
//  ParametersEncodable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol ParametersEncodable {
    func encode() throws -> Data
}
