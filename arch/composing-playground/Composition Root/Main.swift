//
//  Main.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

class Main {
    static func main() {
        let feature1 = FeatureOneUIComposer.compose(loader: loaderOne)
        let feature2 = FeatureTwoUIComposer.compose(loader: loaderTwo)
    }

    static func loaderOne() -> Loader<ModelOne> {
        let cacheKey = "FEATURE_ONE_CACHE_KEY"
        let request = EndpointOne.request(for: .base())
        let cache = InMemoryCacheBuilder.build(
            localModel: LocalOneMapper.toModel,
            modelLocal: LocalOneMapper.fromModel
        )
        let remote = RemoteBuilder
            .remote(for: request)
            .map(DTOOneMapper.toModel)
        return remote
            .fallback(to: remote)
            .logging()
            .saving(to: cache.save, key: cacheKey)
            .fallback(to: .local(cache.load, key: cacheKey))
            .analyse()
            .checkAuth()
            .load
    }
    
    static func loaderTwo(for input: String) -> Loader<ModelTwo> {
        let request = EndpointTwo.request(for: .base(), value: input)
        let cache = InMemoryCacheBuilder.build(
            localModel: LocalTwoMapper.toModel,
            modelLocal: LocalTwoMapper.fromModel
        )
        let remote = RemoteBuilder
            .remote(for: request)
            .map(DTOTwoMapper.toModel)
        return Box.local(cache.load, key: input)
            .fallback(to: remote)
            .logging()
            .fallback(to: remote)
            .saving(to: cache.save, key: input)
            .checkAuth()
            .analyse()
            .load
    }
}
