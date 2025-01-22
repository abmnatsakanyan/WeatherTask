//
//  ApplicationCoordinator.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private var launchInstructor = LaunchInstructor.configure()
    private let viewControllerFactory: ViewControllerFactory = ViewControllerFactory()
        
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
        
    override func start(with option: DeepLinkOption?) {
        if option != nil {
            // Handle deeplinks
        } else {
            switch launchInstructor {
            case .onboarding: runOnboardingFlow()
            case .auth: runAuthFlow()
            case .main: runMainFlow()
            }
        }
    }
    
    private func runAuthFlow() {
        /* Run Authentication flow
         
         let coordinator = self.coordinatorFactory.makeAuthCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
         coordinator.finishFlow = { [unowned self, unowned coordinator] in
         self.removeDependency(coordinator)
         self.launchInstructor = LaunchInstructor.configure(tutorialWasShown: false, isAutorized: true)
         self.start()
         }
         self.addDependency(coordinator)
         coordinator.start()
         */
    }
    
    private func runOnboardingFlow() {
        /* Run Onboarding flow
         
         let coordinator = self.coordinatorFactory.makeOnboardingCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: ViewControllerFactory())
         coordinator.finishFlow = { [unowned self, unowned coordinator] in
         self.removeDependency(coordinator)
         self.launchInstructor = LaunchInstructor.configure(tutorialWasShown: true, isAutorized: true)
         self.start()
         }
         self.addDependency(coordinator)
         coordinator.start()
         */
    }
    
    private func runMainFlow() {
        let coordinator = self.coordinatorFactory.makeWeatherCoordinatorBox(router: self.router,
                                                                            coordinatorFactory: CoordinatorFactory(),
                                                                            viewControllerFactory: ViewControllerFactory())
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.launchInstructor = LaunchInstructor.configure(tutorialWasShown: false, isAutorized: false)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
