//
//  UIKitCoordinaotrsFactory.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

final class UIKitWidgetCoordinatorFactory {
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
            "ACTIVITY": { ActivityUIKitCoordinator(factory: activityWidgetFactory) }
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

// MARK: - STACK

func stackWidgetFactory(id: WidgetId, data: WidgetData) -> (WidgetStackView, StackViewWidgetUpdate) {
    let stack = WidgetStackView()
    let update: StackViewWidgetUpdate = { [weak stack] in
        if let dto = StackDTO.from($0) { stack?.update(model: dto.model) }
    }
    update(data)
    return (stack, update)
}

// MARK: - LABEL

func labelWidgetFactory(id: WidgetId, data: WidgetData) -> (LabelWidget, LabelWidgetUpdate) {
    let label = LabelWidget()
    let update: LabelWidgetUpdate = { [weak label] in
        if let dto = LabelDTO.from($0) { label?.update(with: dto.model) }
    }
    update(data)
    return (label, update)
}

// MARK: - BUTTON

func buttonWidgetFactory(_ intentHandler: IntentHandler) -> ButtonWidgetFactory {{ id, data in
    let button = ButtonWidget(
        onTap: { intentHandler.handle(intent: ButtonIntents.tap, instance: id.instance) }
    )
    let update: ButtonWidgetUpdate = { [weak button] in
        if let dto = ButtonDTO.from($0) { button?.update(with: dto.model) }
    }
    update(data)
    return (button, update)
}}

// MARK: - SWITCH

func switchWidgetFactory(
    intentHandler: IntentHandler,
    storage: InMemoryWidgetDataStorage
) -> SwitchWidgetFactory {{ id, data in
    let stateUpdater = SwitchStateUpdater(
        id: id.instance,
        storage: storage
    )
    let switchWidget = SwitchWidget(
        onTurnOn: {
            stateUpdater.updateStateForOn()
            intentHandler.handle(intent: SwitchIntents.on, instance: id.instance)
        },
        onTurnOff: {
            stateUpdater.updateStateForOff()
            intentHandler.handle(intent: SwitchIntents.off, instance: id.instance)
        }
    )
    let update: ButtonWidgetUpdate = { [weak switchWidget] in
        if let model = SwitchDTO.from($0)?.model {
            stateUpdater.updateLast(model: model)
            switchWidget?.update(with: model)
        }
    }
    update(data)
    return (switchWidget, update)
}}

// MARK: - TOP_LEFT_BOTTOM

func topLeftBottomWidgetFactory(id: WidgetId, data: WidgetData) -> (
    TopLeftBottomWidget,
    TopLeftBottomWidgetUpdate,
    TopLeftBottomWidgetPositioning
) {
    let widget = TopLeftBottomWidget()
    let presenter = TopLeftBottomPresenter(view: widget)
    let update: TopLeftBottomWidgetUpdate = { [weak widget] in
        if let dto = TopLeftBottomDTO.from($0) { widget?.update(with: dto.model) }
    }
    update(data)
    return (widget, update, presenter.present)
}

// MARK: - ACTIVITY

func activityWidgetFactory(id: WidgetId, data: WidgetData) -> (ActivityWidget, ActivityWidgetUpdate) {
    let activity = ActivityWidget()
    let update: ActivityWidgetUpdate = { [weak activity] in
        if let model = ActivityDTO.from($0)?.model { activity?.update(with: model) }
    }
    update(data)
    return (activity, update)
}
