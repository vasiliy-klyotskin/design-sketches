//
//  UIKitWidgetCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import UIKit

protocol UIKitWidgetCoordinator {
    func getView() -> UIView?
    func loadView(for viewModel: UIKitWidgetCreationViewModel)
    func update(with viewModel: UIKitWidgetUpdateViewModel)
    func position(with viewModel: UIKitWidgetPositioningViewModel)
}

struct UIKitWidgetCreationViewModel {
    let id: WidgetId
    let data: WidgetData
}

struct UIKitWidgetPositioningViewModel {
    let positioningChanges: WidgetRenderingViewModel.PositioningChanges
    let children: [WidgetInstanceId: UIView]
    
    var newPositioningData: WidgetPositioning {
        positioningChanges.new.positioning
    }
    
    var oldPositioningData: WidgetPositioning? {
        positioningChanges.old?.positioning
    }
}

struct UIKitWidgetUpdateViewModel {
    let data: WidgetData
}

extension UIKitWidgetCoordinator {
    func getView() -> UIView? { nil }
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {}
    func update(with viewModel: UIKitWidgetUpdateViewModel) {}
    func position(with viewModel: UIKitWidgetPositioningViewModel) {}
}
