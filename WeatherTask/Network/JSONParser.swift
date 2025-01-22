//
//  JSONParser.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation

final class JSONParser: Parsable {
    func parse<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ParserError.onParseError(error)
        }
    }
}
