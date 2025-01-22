//
//  NetworkSession.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

final class NetworkSession: Sessionable {
    var fetcher: Fetchable
    var parser: Parsable

    init(fetcher: Fetchable, parser: Parsable) {
        self.fetcher = fetcher
        self.parser = parser
    }

    func fetchData<T: Decodable>(route: ApiEndpoint) async throws -> T {
        let fetchedResult = try await fetcher.fetch(input: route)

        if let response = fetchedResult.response as? HTTPURLResponse,
           response.statusCode == 401 {
            throw FetcherError.unauthorized
        }

        return try parser.parse(from: fetchedResult.data)
    }
}
