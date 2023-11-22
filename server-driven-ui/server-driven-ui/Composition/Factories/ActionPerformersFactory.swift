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
        renderer: @escaping LocalUpdateContentRenderer,
        refresher: @escaping RefreshHandler
    ) -> ActionPerformer {{ (actionType, actionData) in
        let performers: [AnyHashable: PerformAction] = [
            "REFRESH": refreshPerformerFactory(
                storage: storage,
                refresher: refresher
            ),
            "LOCAL_UPDATE": localUpdatePerformerFactory(
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

func localUpdatePerformerFactory(
    storage: InMemoryWidgetDataStorage,
    renderer: @escaping LocalUpdateContentRenderer
) -> PerformAction {{ actionData in
    guard let action = LocalUpdateContentActionDTO.from(actionData) else { return }
    LocalUpdateContentActionPerformer(
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
