//
//  WeatherCellViewModel.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

final class WeatherCellViewModel {
    let date: String
    let temperature: String
    
    init(date: Date, temperature: Double) {
        self.date = date.formatted()
        self.temperature = "\(temperature) °C"
    }
}
