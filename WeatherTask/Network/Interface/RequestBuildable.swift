//
//  RequestBuildable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol RequestBuildable {
    func createRequest(route: ApiEndpoint) throws -> URLRequest
}
