//
//  ScreenComposer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

enum ScreenComposer {
    static func compose(loader: WidgetLoader) -> RootWidget {
        let root = RootWidget()
        let storage = InMemoryWidgetDataStorage()
        let view = WidgetDifferenceViewProxy()
        let presenter = WidgetRenderingPresenter(view: view)
        let interactor = WidgetsInteractor(
            loader: loader,
            presenter: presenter,
            storage: storage
        )
        let actionPerformer = ActionPerformerFactory.makePerformer(
            storage: storage,
            renderer: interactor.rerenderContent,
            refresher: interactor.beginLoadingNewWidget
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
        view.view = UIKitWidgetCoordinatorRegistry(coordinatorFactory)
        root.onDidLoad = interactor.beginLoadingNewWidgetInitialy
        return root
    }
}
