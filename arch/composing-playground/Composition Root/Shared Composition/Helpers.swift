//
//  Helpers.swift
//  composing-playground
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

extension ResourceErrorView where Self: AnyObject {
    func weakMainErrorView() -> WeakProxy<DispatchDecorator<Self>> {
        WeakProxy(DispatchDecorator(self))
    }
}

extension ResourceLoadingView where Self: AnyObject {
    func weakMainLoadingView() -> WeakProxy<DispatchDecorator<Self>> {
        WeakProxy(DispatchDecorator(self))
    }
}

extension ResourceView where Self: AnyObject {
    func weakMainView() -> WeakProxy<DispatchDecorator<Self>> {
        WeakProxy(DispatchDecorator(self))
    }
}
