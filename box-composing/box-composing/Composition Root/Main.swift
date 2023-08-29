//
//  Main.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

enum Main {
    static func feature1() -> UIViewController {
        FeatureOneUIComposer.compose(loader: loaderOne)
    }
    
    static func feature2() -> UIViewController {
        FeatureTwoUIComposer.compose(loader: loaderTwo)
    }

    private static func loaderOne() -> Loader<ModelOne> {
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
    
    private static func loaderTwo(for input: String) -> Loader<ModelTwo> {
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
