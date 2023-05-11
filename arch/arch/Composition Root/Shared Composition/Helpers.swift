//
//  Helpers.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

func fallback<A, R>(main: @escaping (A) throws -> R, secondary: @escaping (A) throws -> R) -> (A) throws -> R {
    {
        do {
            return try main($0)
        } catch {
            return try secondary($0)
        }
    }
}

func fallback<R>(main: @escaping () throws -> R, secondary: @escaping () throws -> R) -> () throws -> R {
    { try fallback(main: main, secondary: secondary)(()) }
}

func handle<A, R>(action: @escaping (A) throws -> R, handler: @escaping (R, A) -> ()) -> (A) throws -> R {
    {
        let result = try action($0)
        handler(result, $0)
        return result
    }
}

func handle<R>(action: @escaping () throws -> R, handler: @escaping (R) -> ()) -> () throws -> R {
    { try handle(action: action, handler: { (param, _) in handler(param) })(()) }
}

func map<A, B, C>(mapped: @escaping (A) throws -> (B), mapping: @escaping (B) throws -> (C)) -> (A) throws -> (C) {
    { a in
        let b = try mapped(a)
        let c = try mapping(b)
        return c
    }
}
