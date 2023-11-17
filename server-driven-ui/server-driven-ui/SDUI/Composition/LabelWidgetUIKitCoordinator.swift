//
//  LabelWidgetUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

final class LabelUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: (LabelModel, WidgetId) -> LabelWidget
    private let getModel: (WidgetId) -> LabelModel
    
    init(
        factory: @escaping (LabelModel, WidgetId) -> LabelWidget,
        getModel: @escaping (WidgetId) -> LabelModel
    ) {
        self.factory = factory
        self.getModel = getModel
    }
    
    private var label: LabelWidget?
    
    func getView(id: WidgetId) -> UIView {
        if let label {
            return label
        } else {
            let label = factory(getModel(id), id)
            self.label = label
            return label
        }
    }
    
    func update(id: WidgetId) {
        label?.update(with: getModel(id))
    }
}
