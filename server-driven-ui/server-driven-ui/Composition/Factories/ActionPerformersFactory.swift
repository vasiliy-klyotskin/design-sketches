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
        renderer: @escaping UpdateContentRenderer
    ) -> ActionPerformer {{ (actionType, actionData) in
        let performers: [AnyHashable: PerformAction] = [
//            "SUBMIT_FORM": submitPerformerFactory(
//                storage: storage,
//                submit: <#T##SubmitHandler##SubmitHandler##(URL, [WidgetInstanceId : Data]) -> Void#>
//            ),
            "UPDATE_CONTENT": updatePerformerFactory(
                storage: storage,
                renderer: renderer
            )
        ]
        performers[actionType]?(actionData)
    }}
}

// MARK: SUBMIT_FORM Action

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

// MARK: UPDATE_CONTENT Action

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
