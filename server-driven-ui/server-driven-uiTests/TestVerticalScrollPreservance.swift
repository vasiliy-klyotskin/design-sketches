//
//  server_driven_uiTests.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/16/23.
//

import XCTest
import UIKit
@testable import server_driven_ui

final class TestVerticalScrollPreservance: XCTestCase {
    /// Проверяем сохранение позиции скроллинга
    /// 1. Выводим 10 виджетов с высотой 150 поинтов каждый
    /// 2. Скроллим список виджетов к третьему виджету
    /// 3. В исходный список виджетов вставляем между третьим и четвертым еще один виджет (другого типа)
    /// 4. Выводим измененный список не экран
    /// 5. Проверяем, что позиция скроллинга не изменилась
    func test_sdui_replacesChangedWidgetleavingOtherIntact() throws {
        let (sut, loader) = makeSut()
        
        // Выводим 10 виджетов с высотой 150 поинтов каждый
        loader.json = json1
        try sut.attachToScreen()
        
        let widgets1 = getWidgets(from: sut)

        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets1.count, 10)
        
        //Скроллим список виджетов к третьему виджету
        let scrollView = try findScrollView(in: sut)
        let scrollOffset = widgets1[2].frame.origin
        scrollView.contentOffset = scrollOffset
        waitForLayoutPass()

        // Загружаем 11 виджетов, в которых 3-й виджет - новый
        let widgets2 = loadWidgets(in: sut, loader: loader, json: json2)

        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets2.count, 11)
        
        // Проверяем позицию скролла
        XCTAssertEqual(scrollView.contentOffset, scrollOffset)
    }
    
    // MARK: HELPERS
    
    private func makeSut() -> (RootWidget, WidgetLoaderStub) {
        let loader = WidgetLoaderStub()
        let root = TestScreenComposer.compose(loader: loader) as! RootWidget
        return (root, loader)
    }
    
    private func findScrollView(
        in sut: RootWidget,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> UIScrollView {
        guard let view: UIScrollView = sut.findView(in: sut.view) else {
            throw NSError(domain: "Failed to find scroll view", code: 1)
        }
        return view
    }
    
    private func getWidgets(
        from sut: RootWidget,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [UIView] {
        guard let stackView: UIStackView = sut.findView(in: sut.view) else {
            XCTFail("Failed to find stack view", file: file, line: line)
            return []
        }
        return stackView.arrangedSubviews
    }
    
    private func loadWidgets(
        in sut: RootWidget,
        loader: WidgetLoaderStub,
        json: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [UIView] {
        loader.json = json
        if !sut.isViewLoaded {
            sut.triggerLifecycleIfNeeded()
        } else {
            sut.onDidLoad()
        }
        waitForLayoutPass()
        
        return getWidgets(from: sut, file: file, line: line)
    }
    
    private func waitForLayoutPass() {
        RunLoop.main.run(until: Date())
    }
}

extension TestVerticalScrollPreservance {
    var json1: String {
"""
{
    "type": "SCROLL",
    "instance": "scroll",
    "data": {
        "direction": "vertical",
        "contentInsets": { "leading": 0, "top": 0, "trailing": 0, "bottom": 0 }
    },
    "positioning": "stack",
    "children": [
        {
            "type": "STACK",
            "instance": "stack",
            "data": {
                "spacing": 10
            },
            "positioning": ["empty1", "empty2", "empty3", "empty4", "empty5", "empty6", "empty7", "empty8", "empty9", "empty10"],
            "children": [
                {
                    "type": "EMPTY",
                    "instance": "empty1",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty2",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty3",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty4",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty5",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty6",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty7",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty8",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty9",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty10",
                    "data": {
                        "color": "#ff0000"
                    }
                }
            ]
        }
    ]
}
"""
    }
    
    var json2: String {
"""
{
    "type": "SCROLL",
    "instance": "scroll",
    "data": {
        "direction": "vertical",
        "contentInsets": { "leading": 0, "top": 0, "trailing": 0, "bottom": 0 }
    },
    "positioning": "stack",
    "children": [
        {
            "type": "STACK",
            "instance": "stack",
            "data": {
                "spacing": 10
            },
            "positioning": ["empty1", "empty2", "empty3", "empty11", "empty4", "empty5", "empty6", "empty7", "empty8", "empty9", "empty10"],
            "children": [
                {
                    "type": "EMPTY",
                    "instance": "empty1",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty2",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty3",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty11",
                    "data": {
                        "color": "#00ff00"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty4",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty5",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty6",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty7",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty8",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty9",
                    "data": {
                        "color": "#ff0000"
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty10",
                    "data": {
                        "color": "#ff0000"
                    }
                }
            ]
        }
    ]
}
"""
    }
}
