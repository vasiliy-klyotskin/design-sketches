//
//  TestEventAndAction.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 27.11.2023.
//

import XCTest
import UIKit
@testable import server_driven_ui

/*
 Вывести виджет "кнопка", на простое нажатие которой назначено тестовое пустое событие
 Убедиться, что при нажатии на кнопку это событие генерируется
 */

final class TestEventAndAction: XCTestCase {
    func test_sdui_buttonTapLaunchesTestAction() throws {
        let (sut, loader, spy) = makeSut()
        
        // Загружаем виджет кнопка
        loader.json = json
        sut.triggerLifecycleIfNeeded()
        
        guard let button: UIButton = sut.findView(in: sut.view) else {
            XCTFail("Failed to find button")
            return
        }

        button.simulate(event: .touchUpInside)
        
        XCTAssertEqual(spy.messages, ["Action 1", "Action 3"])
    }
    
    // MARK: HELPERS
    
    private func makeSut() -> (RootWidget, WidgetLoaderStub, ActionSpy) {
        let loader = WidgetLoaderStub()
        let spy = ActionSpy()
        let root = TestScreenComposer.compose(loader: loader, testAction: spy.handle) as! RootWidget
        return (root, loader, spy)
    }
}

class ActionSpy {
    var messages: [String] = []
    
    func handle(_ text: String) {
        messages.append(text)
    }
}

extension TestEventAndAction {
    var json: String {
"""
{
    "type": "STACK",
    "instance": "stack",
    "data": {
        "spacing": 10
    },
    "positioning": [
        "button"
    ],
    "children": [
        {
            "type": "BUTTON",
            "instance": "button",
            "data": {
                "title": "Press me"
            },
            "actions": [
                {
                    "type": "TEST",
                    "intent": "BUTTON_TAP",
                    "data": { "text": "Action 1" }
                },
                {
                    "type": "TEST",
                    "intent": "BUTTON_LONG_TAP",
                    "data": { "text": "Action 2" }
                },
                {
                    "type": "TEST",
                    "intent": "BUTTON_TAP",
                    "data": { "text": "Action 3" }
                }
            ]
        }
    ]
}
"""
    }
}
