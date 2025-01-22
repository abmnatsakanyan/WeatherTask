//
//  WeatherResponse.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let lat: Double
    let lon: Double
    let current: WeatherDetail
    let hourly: [WeatherDetail]
    
    struct WeatherDetail: Decodable {
        let dt: Date
        let temp: Double
        let weather: [Weather]
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
