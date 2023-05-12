//
//  LocalLoaderBuilders.swift
//  arch
//
//  Created by Василий Клецкин on 12.05.2023.
//

import Foundation

enum RemoteBuilder<Model, DTO: Decodable> {
    typealias Mapping = (DTO) -> Model
    
    static func remote(for request: URLRequest, mapping: @escaping Mapping) -> Box<Model> {
        let client = URLSessionHTTPClient.shared
        let remote = RemoteUseCase(client: client, mapping: mapping)
        let curried = curry(remote.load)
        return Box(nullCancellable(curried(request)))
    }
}

class InMemoryCacheBuilder<Model, Local> {
    typealias CacheLoad = (String) throws -> Model
    typealias CacheValidate = (String) -> ()
    typealias CacheSave = (Model, String) -> ()
    
    typealias Result = (load: CacheLoad, validate: CacheValidate, save: CacheSave)
    
    static func build(
        localModel: @escaping (Local) -> (Model),
        modelLocal: @escaping (Model) -> (Local)
    ) -> Result {
        let storage = InMemoryStorage<Local>()
        let cache = CacheUseCase(
            storage: storage,
            validation: DefaultCacheValidationPolicy.validate,
            localModel: localModel,
            modelLocal: modelLocal
        )
        return (cache.load, cache.validate, cache.save)
    }
}

extension Box {
    typealias CacheSave = (Output, String) -> Void
    typealias CacheLoad = (String) throws -> Output
    
    func saving(to cache: @escaping CacheSave, key: String) -> Box {
        self.handleSuccess({ cache($0, key) })
    }
    
    static func local(_ load: @escaping CacheLoad, key: String) -> Box {
        self.fromSync({ try load(key) })
    }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

func nullCancellable<T>(_ f: @escaping (T) -> Void) -> (T) -> Cancellable {
    return { x in _ = f(x); return {} }
}
