//
//  QueryEncoder.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

struct QueryEncoder: QueryEncodable {
    var parameters: [String : String] = [:]

    func encode(urlRequest: inout URLRequest) throws {
        guard var component = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true) else {
            throw FetcherError.invalideURL
        }

        component.setQueryItems(params: parameters)

        guard let finalURL = component.url else {
            throw FetcherError.invalideURL
        }

        urlRequest.url = finalURL
    }
}

extension URLComponents {
    mutating func setQueryItems(params: [String: String]) {
        let parameters = params.compactMap { URLQueryItem(name: $0.key, value: $0.value) }

        self.queryItems = parameters
    }
}
