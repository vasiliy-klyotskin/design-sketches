//
//  Cancellables.swift
//  arch
//
//  Created by Василий Клецкин on 12.05.2023.
//

import Foundation


final class LoaderCancellable<Output> {
    var loaderCompletion: LoaderCompletion<Output>?
    
    func complete(with result: LoaderResult<Output>) {
        loaderCompletion?(result)
    }
    
    func cancel() {
        loaderCompletion = nil
    }
}

final class ActionCancellable {
    var onCancel: (() -> Void)?
    
    func cancel() {
        onCancel?()
        onCancel = nil
    }
}
