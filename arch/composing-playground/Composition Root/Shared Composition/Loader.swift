//
//  Helpers.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

typealias Cancellable = () -> Void
typealias LoaderResult<T> = Result<T, Error>
typealias LoaderCompletion<T> = (LoaderResult<T>) -> Void

typealias Loader<Output> = (@escaping LoaderCompletion<Output>) -> Cancellable

final class LoaderCancellable<Output> {
    var loaderCompletion: LoaderCompletion<Output>?
    
    func complete(with result: LoaderResult<Output>) {
        loaderCompletion?(result)
    }
    
    func cancel() {
        loaderCompletion = nil
    }
}

final class CompositeCancellable {
    private var cancellables: [Cancellable] = []
    
    func addCancellable(_ cancellable: @escaping Cancellable) {
        cancellables.append(cancellable)
    }
    
    func cancel() {
        cancellables.forEach { $0() }
        cancellables = []
    }
}
