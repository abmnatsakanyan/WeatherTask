//
//  ParserError.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

enum ParserError: Error {
    case onParseError(_ error: Error)
    case empty
}
