//
//  TestScreenCoposer.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit
@testable import server_driven_ui

enum TestScreenComposer {
    static func compose(loader: WidgetLoader) -> UIViewController {
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

final class UIKitTestWidgetCoordinatorFactory {
    static func coordinatorsFactories(
        storage: InMemoryWidgetDataStorage,
        intentHandler: IntentHandler,
        root: RootWidget
    ) -> [WidgetTypeId: () -> UIKitWidgetCoordinator] {
        [
            "ROOT_CONTAINER": { RootWidgetCoordinator(root: root) },
            "STACK": { StackViewUIKitCoordinator(factory: stackWidgetFactory) },
            "LABEL": { LabelUIKitCoordinator(factory: labelWidgetFactory) },
            "BUTTON": { ButtonUIKitCoordinator(
                factory: buttonWidgetFactory(intentHandler)
            )},
            "SWITCH": { SwitchUIKitCoordinator(
                factory: switchWidgetFactory(
                    intentHandler: intentHandler,
                    storage: storage
                )
            )},
            "TOP_LEFT_BOTTOM": { TopLeftBottomUIKitCoordinator(factory: topLeftBottomWidgetFactory) },
            "ACTIVITY": { ActivityUIKitCoordinator(factory: activityWidgetFactory) },
            "EMPTY": { EmptyWidgetUIKitCoordinator(factory: emptyWidgetFactory) }
        ]
    }
    
    static func makeFactory(
        storage: InMemoryWidgetDataStorage,
        intentHandler: IntentHandler,
        root: RootWidget
    ) -> UIKitCoordinatorFactory {{ typeId in
        let factories = coordinatorsFactories(
            storage: storage,
            intentHandler: intentHandler,
            root: root
        )
        return factories[typeId]!()
    }}
}
