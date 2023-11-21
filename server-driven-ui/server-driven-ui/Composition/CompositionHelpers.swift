//
//  Helpers.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

class WidgetDifferenceViewProxy: WidgetDifferenceView {
    var view: WidgetDifferenceView?
    
    func display(viewModel: WidgetDifferenceViewModel) {
        view?.display(viewModel: viewModel)
    }
}
