//
//  WeatherViewInfoController.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import UIKit
import Combine
import CoreLocation

final class WeatherViewInfoController: UIViewController {
    private let viewModel: WeatherInfoViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let closeButton = LargeTapAreaButton(type: .system)
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()
    private let tableView = UITableView()
    
    init(viewModel: WeatherInfoViewModel) {
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
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        closeButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        closeButton.tintColor = .label
        closeButton.clipsToBounds = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let detailsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, tempLabel])
        detailsStack.axis = .vertical
        detailsStack.spacing = 20
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [imageView, detailsStack])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        view.addSubview(closeButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            stack.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.weatherSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                self?.imageView.load(url: weather.iconURL)
                self?.titleLabel.text = weather.title
                self?.subtitleLabel.text = weather.subtitle
                self?.tempLabel.text = weather.temp
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension WeatherViewInfoController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            fatalError("Could not dequeue cell")
        }
        
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
