//
//  TestActionPerformerFactory.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 28.11.2023.
//

import UIKit
@testable import server_driven_ui

typealias TestAction = (String) -> Void

enum TestActionPerformerFactory {
    static func makePerformer(
        storage: InMemoryWidgetDataStorage,
        renderer: @escaping LocalUpdateContentRenderer,
        refresher: @escaping RefreshHandler,
        testAction: @escaping TestAction
    ) -> ActionPerformer {{ (actionType, actionData) in
        let performers: [AnyHashable: PerformAction] = [
            "REFRESH": refreshPerformerFactory(
                storage: storage,
                refresher: refresher
            ),
            "LOCAL_UPDATE": localUpdatePerformerFactory(
                storage: storage,
                renderer: renderer
            ),
            "TEST": test(perform: testAction)
        ]
        performers[actionType]?(actionData)
    }}
}

// MARK: Test Performer

func test(perform: @escaping (String) -> Void) -> PerformAction {{ actionData in
    guard let action = TestActionDTO.from(actionData) else { return }
    perform(action.text)
}}

struct TestActionDTO: Decodable {
    let text: String
}
