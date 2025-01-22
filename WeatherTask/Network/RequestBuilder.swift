//
//  RequestBuilder.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

struct RequestBuilder: RequestBuildable {
    func createRequest(route: ApiEndpoint) throws -> URLRequest {
        let url = route.baseURL.appendingPathComponent(route.path)

        var request = URLRequest(url: url)

        request.httpMethod = route.method.rawValue
        request.cachePolicy =  route.cachePolicy
        var headers: [String: String] = route.headers
        
        if let additionalHeaders = route.additionalHeaders {
            headers.merge(additionalHeaders, uniquingKeysWith: { firstKey, _ in
                return firstKey
            })
        }

        if !headers.isEmpty {
            headers.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let queryEncoder = route.query {
            do {
                try queryEncoder.encode(urlRequest: &request)
            } catch {
                debugPrint("Recive error when trying to encode query: \(String(describing: route.query))")

                throw URLError(error: error)
            }
        }

        if let bodyEncoder = route.body {
            do {
                try bodyEncoder.encode(request: &request)
            } catch {
                debugPrint("Recive error when trying to encode body: \(String(describing: route.query))")

                 throw URLError(error: error)
            }
        }
        
        return request
    }
}
