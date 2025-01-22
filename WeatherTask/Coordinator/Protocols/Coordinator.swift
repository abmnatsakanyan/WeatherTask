//
//  Coordinator.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/19/25.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    func start(with option: DeepLinkOption?)
}
