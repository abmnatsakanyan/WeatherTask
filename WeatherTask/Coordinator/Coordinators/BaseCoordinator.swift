//
//  BaseCoordinator.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty, let coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func start() {
        start(with: nil)
    }
    
    func start(with option: DeepLinkOption?) {}
}
