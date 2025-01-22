//
//  MapViewModel.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation
import CoreLocation

final class MapViewModel {
    private let permissionManager = PermissionManager.shared
    private let locationService = LocationService()
    
    var openSettingsAlert: (() -> Void)?
    var addAnnotation: ((CLLocationCoordinate2D) -> Void)?
    
    func viewDidLoad() {}
    
    func currentLocationTapped() {
        permissionManager.requestLocationPermission { [weak self] status in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self?.fetchCurrentLocation()
            case .notDetermined:
                break
            default:
                self?.openSettingsAlert?()
            }
        }
    }
    
    private func fetchCurrentLocation() {
        locationService.fetchLocation { [weak self] coordinate in
            self?.addAnnotation?(coordinate)
        }
    }
}
