//
//  WeatherCoordinator.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

final class WeatherCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    
    var finishFlow: (() -> Void)?
    
    init(router: RouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
    override func start() {
        self.showMapViewController()
    }
    
    private func showMapViewController() {
        let mapVC = viewControllerFactory.instantiateMapViewController()
        
        mapVC.onTapInfo = { [unowned self] (longitude, latitude) in
            self.showWeatherInfoViewController(longitude: longitude, latitude: latitude)
        }
        
        mapVC.onTapSettings = { [unowned self] in
            self.showSettingsViewController()
        }
        
        router.setRootModule(mapVC, hideBar: false)
    }
    
    private func showWeatherInfoViewController(longitude: Double, latitude: Double) {
        let weatherInfoVC = viewControllerFactory.instantiateWeatherInfoViewController(longitude: longitude, latitude: latitude)
        
        router.present(weatherInfoVC)
    }
    
    private func showSettingsViewController() {
        let settingsVC = viewControllerFactory.instantiateSettingsViewController()
        
        router.push(settingsVC)
    }
}
