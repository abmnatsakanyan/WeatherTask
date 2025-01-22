//
//  FetchService.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

class FetchService {
    private var fetchManager: Sessionable

    init(fetchManager: Sessionable) {
        self.fetchManager = fetchManager
    }

    func request<T: Decodable>(inputs: ApiEndpoint) async throws -> T {
        return try await fetchManager.fetchData(route: inputs)
    }
}
