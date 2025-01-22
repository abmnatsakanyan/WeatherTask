//
//  Fetchable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol Fetchable {
    func fetch(input: ApiEndpoint) async throws -> (data: Data, response: URLResponse)
}
