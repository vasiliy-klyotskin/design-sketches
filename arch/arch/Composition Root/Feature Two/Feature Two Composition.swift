//
//  Feature Two Composition.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

enum FeatureTwoUIComposer {
    typealias Adapter = ViewAdapter<ModelTwo, DispatchDecorator<Container<FeatureTwoView>>, String>
    
    static func compose(loader: @escaping (String) throws -> ModelTwo) -> UIViewController {
        let controller = FeatureTwoView()
        let container = Container<FeatureTwoView>(
            view: controller,
            errorView: UIViewController(),
            loadingView: UIViewController()
        )
        let presenter = LoadResourcePresenter(
            resourceView: DispatchDecorator(container),
            loadingView: DispatchDecorator(container),
            errorView: DispatchDecorator(container),
            mapper: ViewModelTwoMapper.from
        )
        let adapter = Adapter(
            presenter: presenter,
            loader: loader
        )
        controller.onInput = onBackgroundParam(action: adapter.handle) 
        return container
    }
}
