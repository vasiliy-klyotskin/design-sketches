//
//  Main.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

class SceneDelegate {
    static func main() {
        let feature1 = FeatureOneUIComposer.compose(loader: loaderOne)
        let feature2 = FeatureTwoUIComposer.compose(loader: loaderTwo)
    }

    static func loaderOne() -> Loader<ModelOne> {
        let remote = RemoteBuilder.remote(
            for: EndpointOne.request(for: .base()),
            mapping: DTOOneMapper.toModel
        )
        let cache = InMemoryCacheBuilder.build(
            localModel: LocalOneMapper.toModel,
            modelLocal: LocalOneMapper.fromModel
        )
        let cacheKey = "FEATURE_ONE_CACHE_KEY"
        
        return remote
            .fallback(to: remote)
            .logging()
            .saving(to: cache.save, key: cacheKey)
            .fallback(to: .local(cache.load, key: cacheKey))
            .analyse()
            .checkAuthorization()
            .load
    }
    
    static func loaderTwo(for input: String) -> Loader<ModelTwo> {
        let request = EndpointTwo.request(for: .base(), value: input)
        let remote = RemoteBuilder.remote(for: request, mapping: DTOTwoMapper.toModel)
        let cache = InMemoryCacheBuilder.build(
            localModel: LocalTwoMapper.toModel,
            modelLocal: LocalTwoMapper.fromModel
        )
        return Box.local(cache.load, key: input)
            .fallback(to: remote)
            .logging()
            .fallback(to: remote)
            .saving(to: cache.save, key: input)
            .analyse()
            .checkAuthorization()
            .load
    }
}

enum Analytics {
    static func analyse() {
        // Do analytics
    }
}

enum Logger {
    static func log() {
        // Do logging
    }
}

enum AuthorizationChecker {
    struct UserNotAuthorized: Error {}
    
    static func checkAuthorization() throws {
        throw UserNotAuthorized()
    }
}

extension Box {
    func analyse() -> Box { self.handle({ _ in Analytics.analyse() }) }
}

extension Box {
    func logging() -> Box { self.handle({ _ in Logger.log() }) }
}

extension Box {
    func checkAuthorization() -> Box { self.assert(AuthorizationChecker.checkAuthorization) }
}
