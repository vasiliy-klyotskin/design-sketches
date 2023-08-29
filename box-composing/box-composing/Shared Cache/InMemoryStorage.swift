//
//  InMemoryStorage.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

final class InMemoryStorage<T>: LocalStorage {
    var value: [String: (T, Date)] = [:]
    
    func retrieve(for key: String) -> (T, Date)? {
        return value[key]
    }
    
    func put(value: T, for key: String, timestamp: Date) {
        self.value[key] = (value, timestamp)
    }
    
    func delete(for key: String) {
        self.value[key] = nil
    }
}
