//
//  LocalLoaderBuilders.swift
//  arch
//
//  Created by Василий Клецкин on 12.05.2023.
//

import Foundation

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
    typealias CacheSave = (T, String) -> Void
    typealias CacheLoad = (String) throws -> T
    
    func saving(to cache: @escaping CacheSave, key: String) -> Box {
        self.handleSuccess({ cache($0, key) })
    }
    
    static func local(_ load: @escaping CacheLoad, key: String) -> Box {
        self.fromSync({ try load(key) })
    }
}
