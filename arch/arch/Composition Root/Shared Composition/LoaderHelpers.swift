//
//  Helpers.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

typealias Cancellable = () -> Void
typealias LoaderResult<T> = Result<T, Error>
typealias LoaderCompletion<T> = (LoaderResult<T>) -> Void

typealias Loader<Output> = (@escaping LoaderCompletion<Output>) -> Cancellable

class Box<Output> {
    let load: Loader<Output>
    
    init(_ load: @escaping Loader<Output>) {
        self.load = load
    }
}

extension Box {
    func fallback(to secondary: Box) -> Box {
        Box({ [load] completion in
            let cancellable = ActionCancellable()
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
    
    func map<NewOutput>(_ mapping: @escaping (Output) -> NewOutput) -> Box<NewOutput> {
        Box<NewOutput>({ [load] completion in
            load { result in
                completion(result.map(mapping))
            }
        })
    }
    
    func handle(_ action: @escaping (LoaderResult<Output>) -> Void) -> Box {
        Box({ [load] completion in
            load { result in
                action(result)
                completion(result)
            }
        })
    }
    
    func handleSuccess(_ action: @escaping (Output) -> Void) -> Box {
        handle { result in
            switch result {
            case let .success(value):
                action(value)
            default: break
            }
        }
    }
    
    func assert(_ action: @escaping () throws -> ()) -> Box {
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

extension Box {
    static func fromSync(_ syncLoad: @escaping () throws -> Output) -> Box<Output> {
        Box({ completion in
            let cancellable = LoaderCancellable<Output>()
            cancellable.loaderCompletion = completion
            cancellable.complete(with: Result{ try syncLoad() })
            return cancellable.cancel
        })
    }
}