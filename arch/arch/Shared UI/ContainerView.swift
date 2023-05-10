//
//  ContainerView.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import UIKit

final class Container<View: ResourceView>: UIViewController, ResourceView, ResourceErrorView, ResourceLoadingView {
    
    private var _view: View?
    private var errorView: UIViewController?
    private var loadingView: UIViewController?
    
    var onDisplay: (() -> Void)?
    
    convenience init(view: View, errorView: UIViewController, loadingView: UIViewController) {
        self.init()
        self._view = view
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    typealias ResourceViewModel = View.ResourceViewModel
    
    func display(_ viewModel: ResourceErrorViewModel) {
        // show error
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        // show loading
    }
    
    func display(_ viewModel: ResourceViewModel) {
        // show vm
    }
}
