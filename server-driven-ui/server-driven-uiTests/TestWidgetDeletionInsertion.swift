//
//  server_driven_uiTests.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/16/23.
//

import XCTest
import UIKit
@testable import server_driven_ui

final class TestWidgetDeletionInsertion: XCTestCase {
    /// Проверяем работу умного рендеринга:
    /// 1. Выводим три виджета: 1, 3, 4
    /// 2. Выводим два виджета: 1, 4
    /// Проверяем что средний виджет удалился, а первый и последний остались теми же самыми
    /// 3. Выводим три виджета: 1, 2, 4
    /// Проверяем что новый средний виджет появился, а первый и последний остались теми же самыми
    func test_sdui_removesDisappearedWidgetAndInstallsNewOne() throws {
        let (sut, loader) = makeSut()
        
        // Загружаем три виджета: 1, 3, 4
        let widgets1 = loadWidgets(in: sut, loader: loader, json: json1)
        
        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets1.count, 3)

        // Загружаем два виджета: 1, 4
        let widgets2 = loadWidgets(in: sut, loader: loader, json: json2)

        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets2.count, 2)
        
        // Проверяем что средний виджет удален, а первый и последний остались теми же самыми
        XCTAssertTrue(widgets1[0] === widgets2[0])
        XCTAssertTrue(widgets1[2] === widgets2[1])

        // Загружаем три виджета: 1, 2, 4
        let widgets3 = loadWidgets(in: sut, loader: loader, json: json3)

        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets3.count, 3)
        
        // Проверяем что средний новый виджет вставлен, а первый и последний остались теми же самыми
        XCTAssertTrue(widgets1[0] === widgets3[0])
        XCTAssertTrue(widgets1[1] !== widgets3[1])
        XCTAssertTrue(widgets1[2] === widgets3[2])
    }
    
    // MARK: HELPERS
    
    private func makeSut() -> (RootWidget, WidgetLoaderStub) {
        let loader = WidgetLoaderStub()
        let root = TestScreenComposer.compose(loader: loader, testAction: { _ in }) as! RootWidget
        return (root, loader)
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
        
        guard let stackView: UIStackView = sut.findView(in: sut.view) else {
            XCTFail("Failed to find stack view", file: file, line: line)
            return []
        }
        return stackView.arrangedSubviews
    }
}

extension TestWidgetDeletionInsertion {
    var json1: String {
"""
{
    "type": "STACK",
    "instance": "stack",
    "data": {
        "spacing": 10
    },
    "positioning": [
        "empty1",
        "empty3",
        "empty4"
    ],
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
            "instance": "empty3",
            "data": {
                "color": "#00ff00"
            }
        },
        {
            "type": "EMPTY",
            "instance": "empty4",
            "data": {
                "color": "#0000ff"
            }
        },
    ]
}
"""
    }
    
    var json2: String {
"""
{
    "type": "STACK",
    "instance": "stack",
    "data": {
        "spacing": 10
    },
    "positioning": [
        "empty1",
        "empty4"
    ],
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
            "instance": "empty4",
            "data": {
                "color": "#0000ff"
            }
        },
    ]
}
"""
    }
    
    var json3: String {
"""
{
    "type": "STACK",
    "instance": "stack",
    "data": {
        "spacing": 10
    },
    "positioning": [
        "empty1",
        "empty2",
        "empty4"
    ],
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
                "color": "#00ff00"
            }
        },
        {
            "type": "EMPTY",
            "instance": "empty4",
            "data": {
                "color": "#0000ff"
            }
        },
    ]
}
"""
    }
}
