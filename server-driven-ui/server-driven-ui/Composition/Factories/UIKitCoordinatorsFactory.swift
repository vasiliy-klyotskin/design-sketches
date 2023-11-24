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
            "ACTIVITY": { ActivityUIKitCoordinator(factory: activityWidgetFactory) },
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

// MARK: - STACK

func stackWidgetFactory(id: WidgetId, data: WidgetData) -> (
    WidgetStackView,
    StackViewWidgetUpdate,
    StackViewWidgetPositioning
) {
    let stack = WidgetStackView()
    let presenter = StackPresenter(view: stack)
    let update: StackViewWidgetUpdate = { [weak stack] in
        if let dto = StackDTO.from($0) { stack?.update(model: dto.model) }
    }
    let positioning: StackViewWidgetPositioning = { vm in
        let prevLinOrdering = LinearPositioningDTO.from(vm.previous?.data)?.model
        guard let curLinOrdering = LinearPositioningDTO.from(vm.current.data)?.model else { return }
        presenter.present(previous: prevLinOrdering, current: curLinOrdering, children: vm.children)
    }
    update(data)
    return (stack, update, positioning)
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
    let positioning: TopLeftBottomWidgetPositioning = {
        guard let positioningModel = TopLeftBottomPositioningDTO.from($0.current.data)?.model else { return }
        presenter.present(with: positioningModel, children: $0.children)
    }
    update(data)
    return (widget, update, positioning)
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

// MARK: - SCROLL

func scrollWidgetFactory(id: WidgetId, data: WidgetData) -> (WidgetScrollView, ScrollViewWidgetUpdate, ScrollViewWidgetPositioning) {
    let view = WidgetScrollView()
    let update: ScrollViewWidgetUpdate = { [weak view] in
        if let dto = ScrollDTO.from($0) { view?.update(model: dto.model) }
    }
    let positioning: ScrollViewWidgetPositioning = { vm in
        let prevContentId = ScrollPositioningDTO.from(vm.previous?.data)?.model
        let curContentId: WidgetInstanceId? = ScrollPositioningDTO.from(vm.current.data)?.model ?? vm.children.first?.key
        if prevContentId != curContentId {
            view.deleteContent()
            if let curContentId, let child = vm.children[curContentId] {
                view.setContent(child)
            }
        }
    }
    update(data)
    return (view, update, positioning)
}
