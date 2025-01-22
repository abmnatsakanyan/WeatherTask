//
//  URLError+Error.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

extension URLError {
    init(error: Error) {
        self.init(.unknown)
    }
}
