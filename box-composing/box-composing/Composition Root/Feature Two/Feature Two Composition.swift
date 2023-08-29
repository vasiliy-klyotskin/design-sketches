//
//  Feature Two Composition.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

enum FeatureTwoUIComposer {
    typealias View = WeakProxy<DispatchDecorator<Container<FeatureTwoView>>>
    typealias Adapter = ViewAdapter<ModelTwo, View, String>
    
    static func compose(loader: @escaping (String) -> Loader<ModelTwo>) -> UIViewController {
        let controller = FeatureTwoView()
        let container = Container<FeatureTwoView>(
            view: controller,
            errorView: UIViewController(),
            loadingView: UIViewController()
        )
        let presenter = LoadResourcePresenter(
            resourceView: container.weakMainView(),
            loadingView: container.weakMainLoadingView(),
            errorView: container.weakMainErrorView(),
            mapper: ViewModelTwoMapper.from
        )
        let adapter = Adapter(
            presenter: presenter,
            loader: loader
        )
        controller.onInput = adapter.handle
        return container
    }
}
