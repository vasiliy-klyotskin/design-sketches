//
//  TestScreenCoposer.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit
@testable import server_driven_ui

enum TestScreenComposer {
    static func compose(loader: WidgetLoader, testAction: @escaping (String) -> Void) -> UIViewController {
        let root = RootWidget()
        let storage = InMemoryWidgetDataStorage()
        let view = WidgetDifferenceViewProxy()
        let presenter = WidgetRenderingPresenter(view: view)
        let interactor = WidgetsInteractor(
            loader: loader,
            presenter: presenter,
            storage: storage
        )
        let actionPerformer = TestActionPerformerFactory.makePerformer(
            storage: storage,
            renderer: interactor.rerenderContent,
            refresher: interactor.beginLoadingNewWidget,
            testAction: testAction
        )
        let intentHandler = PerformActionIntentHandler(
            storage: storage,
            performer: actionPerformer
        )
        let coordinatorFactory = UIKitTestWidgetCoordinatorFactory.makeFactory(
            storage: storage,
            intentHandler: intentHandler,
            root: root
        )
        view.view = UIKitWidgetCoordinatorRegistry(coordinatorFactory)
        root.onDidLoad = interactor.beginLoadingNewWidgetInitialy
        return root
    }
}
