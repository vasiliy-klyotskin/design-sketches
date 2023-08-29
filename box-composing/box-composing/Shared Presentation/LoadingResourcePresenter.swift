//
//  LoadingPresenter.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    public init(
        resourceView: View,
        loadingView: ResourceLoadingView,
        errorView: ResourceErrorView,
        mapper: @escaping Mapper
    ) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: error.localizedDescription))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
