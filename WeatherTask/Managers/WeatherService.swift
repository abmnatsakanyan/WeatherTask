//
//  WeatherService.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

protocol WeatherServiceable {
    func fetchWeather(longitude: Double, latitude: Double) async throws -> WeatherResponse
}

final class WeatherService: FetchService, WeatherServiceable {
    func fetchWeather(longitude: Double, latitude: Double) async throws -> WeatherResponse  {
        try await request(inputs: WeatherAPI(longitude: longitude, latitude: latitude))
    }
}

extension WeatherService {
    convenience init() {
        self.init(fetchManager:  NetworkSession(
            fetcher: NetworkFetcher(session: .shared, builder: RequestBuilder()),
            parser: JSONParser()
        ))
    }
}
