//
//  LocalLoaderBuilders.swift
//  composing-playground
//
//  Created by Василий Клецкин on 12.05.2023.
//

import Foundation

typealias CacheLoad<Model> = (String) throws -> Model
typealias CacheValidate = (String) -> ()
typealias CacheSave<Model> = (Model, String) -> ()

enum InMemoryCacheBuilder<Model, Local> {
    typealias Result = (load: CacheLoad<Model>, validate: CacheValidate, save: CacheSave<Model>)
    
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

enum RemoteBuilder<DTO: Decodable> {
    static func remote(for request: URLRequest) -> Box<DTO> {
        let performRequest = curry(URLSessionHTTPClient.shared.perform)(request)
        return Box(nullCancellable(performRequest))
            .tryMap(DTOMapper.map)
    }
}

extension Box {
    func saving(to cache: @escaping CacheSave<Output>, key: String) -> Box {
        handleSuccess({ cache($0, key) })
    }
    
    func analyse() -> Box { doOnResult(Analytics.analyse) }
    func logging() -> Box { doOnResult(Logger.log) }
    func checkAuth() -> Box { ensure(AuthChecker.checkAuth) }
}

extension Box {
    static func local(_ load: @escaping CacheLoad<Output>, key: String) -> Box {
        fromSync({ try load(key) })
    }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

func nullCancellable<T>(_ f: @escaping (T) -> Void) -> (T) -> Cancellable {
    return { x in _ = f(x); return {} }
}
