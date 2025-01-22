//
//  SettingsViewController.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let infoLabel = UILabel()
    
    private let locationCheckmark = UIImageView()
    private let locationStatusLabel = UILabel()
    private let locationLabel = UILabel()
    private let locationButton = UIButton(configuration: .filled())
    
    private let notificationCheckmark = UIImageView()
    private let notificationStatusLabel = UILabel()
    private let notificationLabel = UILabel()
    private let notificationButton = UIButton(configuration: .filled())
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        infoLabel.text = "This app needs both Location(Always) and Notification permissions to provide accurate weather updates for your current location. You can manage these permissions below."
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoLabel)
        
        locationCheckmark.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        locationCheckmark.contentMode = .scaleAspectFit
        setCheckmark(locationCheckmark, isChecked: false)
        locationLabel.text = "Location:"
        locationStatusLabel.text = "Not Allowed"
        locationButton.setTitle("ALWAYS ALLOW", for: .normal)
        locationButton.addTarget(self, action: #selector(requestLocationPermission), for: .touchUpInside)
        
        notificationCheckmark.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        notificationCheckmark.contentMode = .scaleAspectFit
        setCheckmark(notificationCheckmark, isChecked: false)
        notificationLabel.text = "Notification:"
        notificationStatusLabel.text = "Unknown"
        notificationButton.setTitle("ALLOW", for: .normal)
        notificationButton.addTarget(self, action: #selector(requestNotificationPermission), for: .touchUpInside)
        
        let locationStack = UIStackView(arrangedSubviews: [locationCheckmark, locationLabel, locationStatusLabel, locationButton])
        locationStack.spacing = 6
        locationStack.axis = .horizontal
        locationStack.translatesAutoresizingMaskIntoConstraints = false
        
        let notificationStack = UIStackView(arrangedSubviews: [notificationCheckmark, notificationLabel, notificationStatusLabel, notificationButton])
        notificationStack.spacing = 6
        notificationStack.axis = .horizontal
        notificationStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [locationStack, notificationStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -40)
        ])
    }

    private func bindViewModel() {
        viewModel.locationPermissionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.locationStatusLabel.text = status.message
                self.setCheckmark(self.locationCheckmark, isChecked: status.isChechmarkChecked)
                self.locationButton.isHidden = status.isHiddenButton
            }
            .store(in: &cancellables)
        
        viewModel.notificationPermissionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.notificationStatusLabel.text = status.message
                self.setCheckmark(self.notificationCheckmark, isChecked: status.isChechmarkChecked)
                self.notificationButton.isHidden = status.isHiddenButton
            }
            .store(in: &cancellables)
    }
    
    @objc private func requestLocationPermission() {
        showSettingsAlert()
    }
    
    @objc private func requestNotificationPermission() {
        openSettingPage()
    }
    
    private func openSettingPage() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    private func setCheckmark(_ imageView: UIImageView, isChecked: Bool) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let imageName = isChecked ? "checkmark.circle.fill" : "x.circle.fill"
        let color: UIColor = isChecked ? .green : .red
        imageView.image = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Background Location Access Needed",
                                      message: "To provide accurate location-based services, the app requires 'Always' access to your location. Please enable 'Always' in the Location Services settings.",
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
}
