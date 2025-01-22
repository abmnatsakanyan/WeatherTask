//
//  MapViewController.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    var onTapInfo: ((Double, Double) -> Void)?
    var onTapSettings: (() -> Void)?
    
    private var mapView: MKMapView!
    private let currentLocationButton = LargeTapAreaButton(type: .system)
    private var annotation: MKPointAnnotation?
    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.viewDidLoad()
        configureNavigationBar()
        setupMap()
        addTapGesture()
        addRightBarButton()
        setupCurrentLocationButton()
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func bindViewModel() {
        viewModel.openSettingsAlert = { [weak self] in
            self?.showSettingsAlert()
        }
        
        viewModel.addAnnotation = { [weak self] coordinate in
            self?.addAnnotation(coordinate: coordinate)
            self?.setRegion(coordinate: coordinate)
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Location services are off",
                                      message: "To use background location, you must enable 'Always' in the Location Services settings",
                                      preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { [weak self] _ in
            self?.openSettingPage()
            alert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        present(alert, animated: true)
    }
    
    private func openSettingPage() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    private func setupMap() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapView)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: mapView)
        
        if let tappedView = mapView.hitTest(tapLocation, with: nil) as? MKAnnotationView {
            mapView.selectAnnotation(tappedView.annotation!, animated: true)
            return
        }
        
        let coordinate = mapView.convert(tapLocation, toCoordinateFrom: mapView)
       
        addAnnotation(coordinate: coordinate)
    }
    
    private func addRightBarButton() {
        let image = UIImage(systemName: "gear")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func rightBarButtonTapped() {
        onTapSettings?()
    }
    
    private func setupCurrentLocationButton() {
        currentLocationButton.setImage(UIImage(systemName: "scope"), for: .normal)
        currentLocationButton.tintColor = .white
        currentLocationButton.backgroundColor = .systemBlue
        currentLocationButton.layer.cornerRadius = 22
        currentLocationButton.clipsToBounds = true
        
        currentLocationButton.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 100, width: 44, height: 44)
        currentLocationButton.addTarget(self, action: #selector(userLocationTapped), for: .touchUpInside)
        
        view.addSubview(currentLocationButton)
    }
    
    @objc private func userLocationTapped() {
        viewModel.currentLocationTapped()
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D) {
        if let annotation {
            mapView.removeAnnotation(annotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        self.annotation = annotation
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            let placemark = placemarks?.first
            self.annotation?.title = placemark?.administrativeArea
            self.annotation?.subtitle = placemark?.locality
        }
    }
    
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.titleVisibility = .hidden
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let coordinate = annotation?.coordinate {
            onTapInfo?(coordinate.longitude, coordinate.latitude)
        }
    }
}
