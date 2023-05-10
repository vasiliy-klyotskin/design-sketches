//
//  Main.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

class SceneDelegate {
    func main() {
        let _ = featureOne()
        let _ = featureTwo()
    }
    
    private func featureOne() -> UIViewController {
        let remote = RemoteBuilder.remote(
            for: EndpointOne.request(for: .base()),
            mapping: DTOOneMapper.toModel
        )
        let cache = InMemoryCacheBuilder.curriedCache(
            localModel: LocalOneMapper.toModel,
            modelLocal: LocalOneMapper.fromModel
        )
        let fallback = fallback(main: remote, secondary: cache.load)
        let featureOne = FeatureOneUIComposer.compose(loader: fallback)
        return featureOne
    }
    
    private func featureTwo() -> UIViewController {
        let remote = RemoteBuilder.defaultRemote(mapping: DTOTwoMapper.toModel)
        let mappedRemote = map(
            mapped: { EndpointTwo.request(for: .base(), value: $0) },
            mapping: remote
        )
        let cache = InMemoryCacheBuilder.defaultCache(
            localModel: LocalTwoMapper.toModel,
            modelLocal: LocalTwoMapper.fromModel
        )
        let savingRemote = handle(action: mappedRemote, handler: cache.save)
        let remoteToRemoteFallback = fallbackParam(main: savingRemote, secondary: savingRemote)
        let localFallback = fallbackParam(main: remoteToRemoteFallback, secondary: cache.load)
        return FeatureTwoUIComposer.compose(loader: localFallback)
    }
}
