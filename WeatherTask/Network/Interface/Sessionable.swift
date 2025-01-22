//
//  Sessionable.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol Sessionable {
    var fetcher: Fetchable { get }
    var parser: Parsable { get }

    init(fetcher: Fetchable, parser: Parsable)

    func fetchData<T: Decodable>(route: ApiEndpoint) async throws -> T
}
