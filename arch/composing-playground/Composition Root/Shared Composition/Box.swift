//
//  Box.swift
//  composing-playground
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

class Box<Output> {
    let load: Loader<Output>
    
    init(_ load: @escaping Loader<Output>) {
        self.load = load
    }
}

extension Box {    
    func fallback(to secondary: Box) -> Box {
        Box { completion in
            let cancellable = CompositeCancellable()
            cancellable.addCancellable(self.load { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure:
                    cancellable.addCancellable(secondary.load(completion))
                }
            })
            return cancellable.cancel
        }
    }
    
    func tryMap<NewOutput>(_ mapping: @escaping (Output) throws -> NewOutput) -> Box<NewOutput> {
        Box<NewOutput> { [load] completion in
            load { result in
                completion(result.flatMap { output -> Result<NewOutput, Error> in
                    Result { try mapping(output) }
                })
            }
        }
    }
    
    func map<NewOutput>(_ mapping: @escaping (Output) -> NewOutput) -> Box<NewOutput> {
        tryMap(mapping)
    }
    
    func handle(_ action: @escaping (LoaderResult<Output>) -> Void) -> Box {
        Box { [load] completion in
            load { result in
                action(result)
                completion(result)
            }
        }
    }
    
    func handleSuccess(_ action: @escaping (Output) -> Void) -> Box {
        handle { result in
            if case let .success(value) = result {
                action(value)
            }
        }
    }
    
    func ensure(_ action: @escaping () throws -> ()) -> Box {
        Box { [load] completion in
            do {
                try action()
                return load(completion)
            } catch {
                completion(.failure(error))
            }
            return {}
        }
    }
}

extension Box {
    static func fromSync(_ syncLoad: @escaping () throws -> Output) -> Box {
        Box { completion in
            let cancellable = LoaderCancellable<Output>()
            cancellable.loaderCompletion = completion
            cancellable.complete(with: Result{ try syncLoad() })
            return cancellable.cancel
        }
    }
}
