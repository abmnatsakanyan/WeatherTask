//
//  WeatherInfoViewModel.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation
import Combine

final class WeatherInfoViewModel {
    typealias WeatherInfo = (title: String?, subtitle: String?, temp: String, iconURL: URL?)
    
    private let longitude: Double
    private let latitude: Double
    private let weatherService = WeatherService()
    
    let weatherSubject = PassthroughSubject<WeatherInfo, Never>()
    
    private var cellViewModels: [WeatherCellViewModel] = []
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        cellViewModels.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> WeatherCellViewModel {
        cellViewModels[indexPath.row]
    }

    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
        
    func viewDidLoad() {
        fetchWeatherInfo()
    }

    private func fetchWeatherInfo() {
        Task {
            do {
                let weatherData = try await weatherService.fetchWeather(longitude: longitude, latitude: latitude)
                print(weatherData)
                let weather = weatherData.current.weather.first
                
                var iconURL: URL?
                
                if let icon = weather?.icon {
                    iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                }
                
                self.cellViewModels = weatherData.hourly.map {
                    WeatherCellViewModel(date: $0.dt, temperature: $0.temp)
                }
                
                self.weatherSubject.send((
                    weather?.main,
                    weather?.description,
                    "Temperature: \(weatherData.current.temp)°C",
                    iconURL
                ))
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
