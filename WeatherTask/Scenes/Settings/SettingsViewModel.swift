//
//  SettingsViewModel.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation
import Combine

final class SettingsViewModel {
    typealias PermissionInfo = (message: String, isHiddenButton: Bool, isChechmarkChecked: Bool)
    
    let locationPermissionSubject = PassthroughSubject<PermissionInfo, Never>()
    let notificationPermissionSubject = PassthroughSubject<PermissionInfo, Never>()
    
    func viewDidLoad() {
        requestLocationPermission()
        requestNotificationPermission()
    }
    
    private let permissionManager = PermissionManager.shared
    
    func requestLocationPermission() {
        permissionManager.requestLocationPermission { [weak self] status in
            guard let self else { return }
            
            let isGranted = status == .authorizedAlways
            let message = isGranted ? "Allowed" : "Not Allowed"
            self.locationPermissionSubject.send((message, isGranted, isGranted))
        }
    }
    
    func requestNotificationPermission() {
        permissionManager.notificationStatus = { [weak self] status in
            guard let self else { return }
            
            let isGranted = status == .authorized
            let message = isGranted ? "Allowed" : "Not Allowed"
            self.notificationPermissionSubject.send((message, isGranted, isGranted))
        }
        
        permissionManager.checkNotificationPermission()
    }
}
