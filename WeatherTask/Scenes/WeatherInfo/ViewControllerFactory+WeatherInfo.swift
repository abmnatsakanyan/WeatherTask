//
//  ViewControllerFactory+WeatherInfo.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

extension ViewControllerFactory {
    func instantiateWeatherInfoViewController(longitude: Double, latitude: Double) -> WeatherViewInfoController {
        let viewModel = WeatherInfoViewModel(longitude: longitude, latitude: latitude)
        let viewController = WeatherViewInfoController(viewModel: viewModel)
            
        return viewController
    }
}
