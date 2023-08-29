//
//  WeakProxy.swift
//  box-composing
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

final class WeakProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakProxy: ResourceView where T: ResourceView {
    func display(_ viewModel: T.ResourceViewModel) {
        object?.display(viewModel)
    }
}

extension WeakProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}
