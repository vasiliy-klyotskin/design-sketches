//
//  Helpers.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

class WidgetDifferenceViewProxy: WidgetRenderingView {
    var view: WidgetRenderingView?
    
    func display(viewModel: WidgetRenderingViewModel) {
        view?.display(viewModel: viewModel)
    }
}
