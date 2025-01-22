//
//  FetcherError.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

enum FetcherError: Error, LocalizedError {
    case invalideURL
    case unauthorized
    case failedRefreshToken
    case internetConnectionError
    case urlError(error: URLError)
    case network(Error?, response: HTTPURLResponse)

    public var errorDescription: String? {
        switch self {
        case .network(let error, _) where error != nil:
            return NSLocalizedString(error!.localizedDescription, comment: "error")
        case .internetConnectionError:
            return "Please check your network settings and try again"
        default:
            return NSLocalizedString("Unknown error", comment: "error")
        }
    }

    public var failureReason: String? {
        switch self {
        case .internetConnectionError:
            return "Internet Connection Unreachable"
        default:
            return "Error"
        }
    }
}
