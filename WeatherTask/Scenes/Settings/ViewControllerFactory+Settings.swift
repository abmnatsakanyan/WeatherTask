//
//  ViewControllerFactory+Settings.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit

extension ViewControllerFactory {
    func instantiateSettingsViewController() -> SettingsViewController {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel)
            
        return viewController
    }
}
