//
//  Helpers.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

typealias Cancellable = () -> Void
typealias LoaderResult<T> = Result<T, Error>

typealias Loader<R> = (@escaping (LoaderResult<R>) -> Void) -> Cancellable

class Box<T> {
    let load: Loader<T>
    
    init(_ load: @escaping Loader<T>) {
        self.load = load
    }
    
    static func fromSync(_ syncLoad: @escaping () throws -> T) -> Box<T> {
        Box({ [syncLoad] completion in
            let cancellable = AnyCancellable()
            // TODO: обработка Cancellable
            completion(Result{ try syncLoad() })
            return cancellable.cancel
        })
    }
}

extension Box {
    func fallback(to secondary: Box<T>) -> Box<T> {
        Box({ [load] completion in
            let cancellable = AnyCancellable()
            cancellable.onCancel = load { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure:
                    cancellable.onCancel = secondary.load { secondaryResult in
                        switch result {
                        case .success(let secondResponse):
                            completion(.success(secondResponse))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
            return cancellable.cancel
        })
    }
    
    func map<N>(_ mapping: @escaping (T) -> N) -> Box<N> {
        Box<N>({ [load] completion in
            load { result in
                completion(result.map(mapping))
            }
        })
    }
    
    func handle(_ action: @escaping (LoaderResult<T>) -> Void) -> Box<T> {
        Box({ [load] completion in
            load { result in
                action(result)
                completion(result)
            }
        })
    }
    
    func handleSuccess(_ action: @escaping (T) -> Void) -> Box<T> {
        handle { result in
            switch result {
            case let .success(value):
                action(value)
            default: break
            }
        }
    }
    
    func assert(_ action: @escaping () throws -> ()) -> Box<T> {
        Box({ [load] completion in
            do {
                try action()
                return load(completion)
            } catch {
                completion(.failure(error))
            }
            return {}
        })
    }
}

private class AnyCancellable {
    var onCancel: (() -> Void)?
    
    func cancel() {
        onCancel?()
    }
}

func nullCancellable<T>(_ f: @escaping (T) -> Void) -> (T) -> Cancellable {
    return { x in _ = f(x); return {} }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) } }
}
