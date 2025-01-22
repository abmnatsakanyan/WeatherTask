//
//  WeatherAPI.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

struct WeatherAPI: ApiEndpoint {
    var baseURL: URL = URL(string: "https://api.openweathermap.org/data/3.0/")!
    var path: String = "onecall"
    var method: RequestMethod = .get
    var query: QueryEncodable?
        
    init(longitude: Double, latitude: Double) {
        path = "onecall"
        
        query = QueryEncoder(parameters: [
            "lat":"\(latitude)",
            "lon":"\(longitude)",
            "exclude":"minutely,daily",
            "apiKey":"13eea8dac0c4e8dd3fe9236556f50389",
            "units":"metric"
        ])
    }
}
