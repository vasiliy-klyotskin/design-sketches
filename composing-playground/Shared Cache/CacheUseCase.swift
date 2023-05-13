//
//  CacheUseCase.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

final class CacheUseCase<Storage: LocalStorage, Model> {
    struct NoValue: Error {}
    
    let storage: Storage
    let validation: (Date) -> Bool
    let localModel: (Storage.Local) -> Model
    let modelLocal: (Model) -> Storage.Local
    
    init(
        storage: Storage,
        validation: @escaping (Date) -> Bool,
        localModel: @escaping (Storage.Local) -> Model,
        modelLocal: @escaping (Model) -> Storage.Local
    ) {
        self.storage = storage
        self.validation = validation
        self.localModel = localModel
        self.modelLocal = modelLocal
    }
    
    func load(for key: String) throws -> Model {
        guard let cache = try? storage.retrieve(for: key) else { throw NoValue() }
        let model = localModel(cache.0)
        return model
    }
    
    func validate(for key: String) {
        guard let cache = try? storage.retrieve(for: key) else { return }
        let isValid = validation(cache.1)
        if !isValid { storage.delete(for: key) }
    }
    
    func save(_ model: Model, for key: String) {
        let local = modelLocal(model)
        try? storage.put(value: local, for: key, timestamp: Date())
    }
}
