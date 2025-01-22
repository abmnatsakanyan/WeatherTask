//
//  ViewControllerFactory+Map.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit

extension ViewControllerFactory {
    func instantiateMapViewController() -> MapViewController {
        let viewModel = MapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
            
        return viewController
    }
}
