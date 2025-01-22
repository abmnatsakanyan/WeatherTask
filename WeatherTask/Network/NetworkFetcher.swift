//
//  NetworkFetcher.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

final class NetworkFetcher: Fetchable {
    private let session: URLSession
    private let requestBuilder: RequestBuildable

    init(
        session: URLSession = .shared,
        builder: RequestBuildable
    ) {
        self.session = session
        requestBuilder = builder
    }

    func fetch(input: ApiEndpoint) async throws -> (data: Data, response: URLResponse) {
        do {
            let urlRequest = try requestBuilder.createRequest(route: input)
            return try await session.data(for: urlRequest)
        } catch let error as URLError {
            switch error.code {
            case URLError.Code.notConnectedToInternet,
                URLError.Code.dataNotAllowed,
                URLError.Code.internationalRoamingOff:
                throw FetcherError.internetConnectionError
            default:
                throw FetcherError.urlError(error: error)
            }
        }
    }
}
