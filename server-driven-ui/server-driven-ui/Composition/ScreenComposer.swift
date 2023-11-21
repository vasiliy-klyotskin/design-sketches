//
//  ScreenComposer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

enum ScreenComposer {
    static func compose(loader: WidgetLoader) -> UIViewController {
        let root = RootWidget()
        let storage = InMemoryWidgetDataStorage()
        let interactor = WidgetsInteractor(
            loader: loader,
            presenter: <#T##WidgetDifferencePresenter#>,
            storage: storage
        )
        let actionPerformer = ActionPerformerFactory.makePerformer(
            storage: storage,
            renderer: interactor.rerenderContent
        )
        let intentHandler = PerformActionIntentHandler(
            storage: storage,
            performer: actionPerformer
        )
        let coordinatorFactory = UIKitWidgetCoordinatorFactory.makeFactory(
            storage: storage,
            intentHandler: intentHandler,
            root: root
        )
        let registry = UIKitWidgetCoordinatorRegistry(coordinatorFactory)
        let presenter = WidgetDifferencePresenter(view: registry)
        return root
    }
}
