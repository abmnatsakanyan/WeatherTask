//
//  CoordinatorFactory.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeWeatherCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> WeatherCoordinator
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeWeatherCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> WeatherCoordinator {
        return WeatherCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
    }
}
