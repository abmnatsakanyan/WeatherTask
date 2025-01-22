//
//  ReminderManager.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/20/25.
//

import Foundation
import CoreLocation

final class ReminderManager {
    private let backgroundService: BackgroundServiceable
    private let localNotificationService: LocalNotificationServiceable
    private let weatherService: WeatherServiceable
    private let locationService: LocationService
    
    init(backgroundService: BackgroundServiceable,
         localNotificationService: LocalNotificationServiceable,
         weatherService: WeatherServiceable,
         locationService: LocationService
    ) {
        self.backgroundService = backgroundService
        self.localNotificationService = localNotificationService
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    func start() {
        backgroundService.start() { [weak self] in
            self?.fetchLocation()
        }
    }
    
    private func fetchLocation() {
        locationService.requestLocation { [weak self] coordinate in
            self?.fetchWeather(longitude: coordinate.longitude,
                               latitude: coordinate.latitude)
        }
    }
    
    private func fetchWeather(longitude: Double, latitude: Double) {
        Task {
            do {
                let weatherData = try await weatherService.fetchWeather(longitude: longitude, latitude: latitude)
                print(weatherData)
                localNotificationService.scheduleNotification(title: "Fresh Weather Update 🌤️",
                                                              body: "The current temperature in your area is \(weatherData.current.temp)°C")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
