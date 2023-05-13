//
//  ViewAdapter.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

final class ViewAdapter<Model, View: ResourceView, Request> {
    private let presenter: LoadResourcePresenter<Model, View>
    private let loader: (Request) -> Loader<Model>
    private var cancel: Cancellable?
    
    init(presenter: LoadResourcePresenter<Model, View>, loader: @escaping (Request) -> Loader<Model>) {
        self.presenter = presenter
        self.loader = loader
    }
    
    func handle(_ input: Request) {
        cancelTask()
        presenter.didStartLoading()
        let load = loader(input)
        cancel = load() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.presenter.didFinishLoading(with: model)
            case .failure(let error):
                self.presenter.didFinishLoading(with: error)
            }
        }
    }
    
    func cancelTask() {
        cancel?()
        cancel = nil
    }
}

extension ViewAdapter where Request == Void {
    func handle() { handle(()) }
}
