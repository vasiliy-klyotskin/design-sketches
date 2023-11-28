//
//  UIKitTestWidgetCoordinatorFactory.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 28.11.2023.
//

import UIKit
@testable import server_driven_ui

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
            "EMPTY": { EmptyWidgetUIKitCoordinator(factory: emptyWidgetFactory) },
            "SCROLL": { ScrollViewUIKitCoordinator(factory: scrollWidgetFactory) }
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
