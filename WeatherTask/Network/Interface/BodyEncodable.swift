//
//  BodyEncodable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol BodyEncodable {
    var parametersEncodable: ParametersEncodable { get }

    func encode(request: inout URLRequest) throws
}
