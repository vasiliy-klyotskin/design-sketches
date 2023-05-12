//
//  Composition.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

enum FeatureOneUIComposer {
    typealias Adapter = ViewAdapter<ModelOne, DispatchDecorator<Container<FeatureOneView>>, Void>
    
    static func compose(loader: @escaping () -> Loader<ModelOne>) -> UIViewController {
        let controller = FeatureOneView()
        let container = Container<FeatureOneView>(
            view: controller,
            errorView: UIViewController(),
            loadingView: UIViewController()
        )
        let presenter = LoadResourcePresenter(
            resourceView: DispatchDecorator(container),
            loadingView: DispatchDecorator(container),
            errorView: DispatchDecorator(container),
            mapper: ViewModelOneMapper.from
        )
        let adapter = Adapter(
            presenter: presenter,
            loader: loader
        )
        container.onDisplay = adapter.handle
        return container
    }
}
