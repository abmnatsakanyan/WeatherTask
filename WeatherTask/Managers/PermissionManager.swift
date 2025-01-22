//
//  PermissionManager.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation
import CoreLocation
import UserNotifications

final class PermissionManager: NSObject {
    static let shared = PermissionManager()

    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    private var locationCompletion: ((CLAuthorizationStatus) -> Void)?
    var notificationStatus: ((UNAuthorizationStatus) -> Void)?

    override private init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Location
    
    func checkLocationPermission() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    func requestLocationPermission(completion: @escaping (CLAuthorizationStatus) -> Void) {
        locationCompletion = completion
        let currentStatus = locationManager.authorizationStatus
        
        if currentStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            if currentStatus == .authorizedWhenInUse {
                locationManager.requestAlwaysAuthorization()
            }
            completion(currentStatus)
        }
    }

    // MARK: - Notification
    
    func checkNotificationPermission() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                
                if settings.authorizationStatus == .notDetermined {
                    self.requestNotificationPermission()
                }
                
                self.notificationStatus?(settings.authorizationStatus)
            }
        }
    }
    
    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
}

extension PermissionManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationCompletion?(manager.authorizationStatus)
    }
}
