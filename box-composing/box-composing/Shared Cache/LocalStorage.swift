//
//  LocalStorage.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

protocol LocalStorage {
    associatedtype Local
    
    func retrieve(for key: String) throws -> (Local, Date)?
    func put(value: Local, for key: String, timestamp: Date) throws
    func delete(for key: String)
}
