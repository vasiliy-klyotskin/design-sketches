//
//  SerializationHelpers.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

extension Decodable {
    static func from(_ data: Data?) -> Self? {
        data.map { try! JSONDecoder().decode(Self.self, from: $0) }
    }
}
