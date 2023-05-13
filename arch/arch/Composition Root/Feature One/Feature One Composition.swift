//
//  Composition.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

enum FeatureOneUIComposer {
    typealias View = WeakProxy<DispatchDecorator<Container<FeatureOneView>>>
    typealias Adapter = ViewAdapter<ModelOne, View, Void>
    
    static func compose(loader: @escaping () -> Loader<ModelOne>) -> UIViewController {
        let controller = FeatureOneView()
        let container = Container<FeatureOneView>(
            view: controller,
            errorView: UIViewController(),
            loadingView: UIViewController()
        )
        let presenter = LoadResourcePresenter(
            resourceView: WeakProxy(DispatchDecorator(container)),
            loadingView: WeakProxy(DispatchDecorator(container)),
            errorView: WeakProxy(DispatchDecorator(container)),
            mapper: ViewModelOneMapper.from
        )
        let adapter = Adapter(
            presenter: presenter,
            loader: loader
        )
        container.onDisplay = adapter.handle
        controller.onCancel = adapter.cancelTask
        return container
    }
}
