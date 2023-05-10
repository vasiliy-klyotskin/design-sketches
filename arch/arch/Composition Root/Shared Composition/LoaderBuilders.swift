//
//  CacheBuilder.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

class InMemoryCacheBuilder<Model, Local> {
    typealias CacheLoad = (String) throws -> Model
    typealias CacheValidate = (String) -> ()
    typealias CacheSave = (Model, String) -> ()
    
    typealias Result = (load: CacheLoad, validate: CacheValidate, save: CacheSave)
    
    static func defaultCache(
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
    
    typealias CurriedCacheLoad = () throws -> Model
    typealias CurriedCacheValidate = () -> ()
    typealias CurriedCacheSave = (Model) -> ()
    
    typealias CurriedResult = (load: CurriedCacheLoad, validate: CurriedCacheValidate, save: CurriedCacheSave)
    
    static func curriedCache(
        localModel: @escaping (Local) -> (Model),
        modelLocal: @escaping (Model) -> (Local)
    ) -> CurriedResult {
        let defaultKey = "unique key"
        let defaultCache = defaultCache(localModel: localModel, modelLocal: modelLocal)
        let load = { try defaultCache.load(defaultKey) }
        let validate = { defaultCache.validate(defaultKey) }
        let save = { defaultCache.save($0, defaultKey) }
        return (load, validate, save)
    }
}

enum RemoteBuilder<Model, DTO: Decodable> {
    typealias Mapping = (DTO) -> Model
    typealias RemoteLoad = (URLRequest) throws -> Model
    
    static func defaultRemote(mapping: @escaping Mapping) -> (URLRequest) throws -> Model {
        let client = URLSessionHTTPClient.shared
        let remote = RemoteUseCase(client: client, mapping: mapping)
        return remote.load(from:)
    }
    
    static func remote(for request: URLRequest, mapping: @escaping Mapping) -> () throws -> Model {
        { try defaultRemote(mapping: mapping)(request) }
    }
}
