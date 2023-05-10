//
//  ViewAdapter.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

final class ViewAdapter<Model, View: ResourceView, T> {
    let presenter: LoadResourcePresenter<Model, View>
    let loader: (T) throws -> Model
    
    init(presenter: LoadResourcePresenter<Model, View>, loader: @escaping (T) throws -> Model) {
        self.presenter = presenter
        self.loader = loader
    }
    
    func handle(_ input: T) {
        presenter.didStartLoading()
        do {
            let model = try loader(input)
            presenter.didFinishLoading(with: model)
        } catch {
            presenter.didFinishLoading(with: error)
        }
    }
}

extension ViewAdapter where T == Void {
    func handle() { handle(()) }
}
