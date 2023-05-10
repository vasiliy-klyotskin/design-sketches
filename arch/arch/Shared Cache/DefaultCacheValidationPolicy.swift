//
//  DefaultCacheValidationPolicy.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum DefaultCacheValidationPolicy {
    static func validate(date: Date) -> Bool {
        return true // логика сравнения с текущей датой
    }
}
