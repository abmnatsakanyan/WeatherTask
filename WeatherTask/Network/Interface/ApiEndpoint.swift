//
//  ApiEndpoint.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

protocol ApiEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var method: RequestMethod { get }

    var query: QueryEncodable? { get }
    var body: BodyEncodable? { get }

    var additionalHeaders: [String: String]? { get }
    var succededStatusCodes: Set<ClosedRange<Int>> { get }

    var cachePolicy: URLRequest.CachePolicy { get }
}

extension ApiEndpoint {
    var headers: [String: String] { [:] }
    var query: QueryEncodable? { nil }
    var body: BodyEncodable? { nil }
    var additionalHeaders: [String: String]? { nil }
    var succededStatusCodes: Set<ClosedRange<Int>> { Set([200...299]) }

    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}
