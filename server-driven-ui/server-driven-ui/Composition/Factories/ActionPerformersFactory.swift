//
//  ActionPerformerFactory.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

typealias PerformAction = (ActionModel) -> Void

enum ActionPerformerFactory {
    static func makePerformer(
        storage: InMemoryWidgetDataStorage,
        renderer: @escaping UpdateContentRenderer,
        refresher: @escaping RefreshHandler
    ) -> ActionPerformer {{ (actionType, actionData) in
        let performers: [AnyHashable: PerformAction] = [
            "REFRESH": refreshPerformerFactory(
                storage: storage,
                refresher: refresher
            ),
            "UPDATE_CONTENT": updatePerformerFactory(
                storage: storage,
                renderer: renderer
            )
        ]
        performers[actionType]?(actionData)
    }}
}

// MARK: REFRESH Performer

func refreshPerformerFactory(
    storage: InMemoryWidgetDataStorage,
    refresher: @escaping RefreshHandler
) -> PerformAction {{ actionData in
    guard let action = RefreshActionDTO.from(actionData) else { return }
    RefreshActionPerformer(
        action: action.model,
        storage: storage,
        refreshHandler: refresher
    ).perform()
}}

// MARK: UPDATE_CONTENT Performer

func updatePerformerFactory(
    storage: InMemoryWidgetDataStorage,
    renderer: @escaping UpdateContentRenderer
) -> PerformAction {{ actionData in
    guard let action = UpdateContentActionDTO.from(actionData) else { return }
    UpdateContentActionPerformer(
        action: action.model,
        storage: storage,
        rerender: renderer
    ).perform()
}}

// MARK: SUBMIT_FORM Performer

func submitPerformerFactory(
    storage: InMemoryWidgetDataStorage,
    submit: @escaping SubmitHandler
) -> PerformAction {{ actionData in
    guard let action = SubmitFormActionDTO.from(actionData) else { return }
    SubmitFormActionPerformer(
        action: action.model,
        storage: storage,
        submit: submit
    ).perform()
}}
