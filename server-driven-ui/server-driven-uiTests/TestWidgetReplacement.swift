//
//  server_driven_uiTests.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/16/23.
//

import XCTest
import UIKit
@testable import server_driven_ui

final class TestWidgetReplacement: XCTestCase {
    /// Проверяем работу умного рендеринга:
    /// 1. Выводим три виджета: 1, 3, 4
    /// 2. Выводим три виджета: 1, 2, 4
    /// Проверяем что средний виджет заменился, а первый и последний остались теми же самыми
    func test_sdui_replacesChangedWidgetleavingOtherIntact() throws {
        let (sut, loader) = makeSut()
        
        // Загружаем три виджета: 1, 3, 4
        loader.json = json1
        sut.triggerLifecycleIfNeeded()
        
        guard let stackView: UIStackView = sut.findView(in: sut.view) else {
            XCTFail("Failed to find stack view")
            return
        }
        let widgets1 = stackView.arrangedSubviews
        
        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets1.count, 3)
        XCTAssertEqual(widgets1[0].backgroundColor?.toHexString(), "#ff0000")
        XCTAssertEqual(widgets1[1].backgroundColor?.toHexString(), "#00ff00")
        XCTAssertEqual(widgets1[2].backgroundColor?.toHexString(), "#0000ff")

        // Загружаем три виджета: 1, 2, 4
        loader.json = json2
        sut.viewDidLoad()
        
        guard let stackView: UIStackView = sut.findView(in: sut.view) else {
            XCTFail("Failed to find stack view")
            return
        }
        let widgets2 = stackView.arrangedSubviews
        
        // Проверяем правильность рендеринга
        XCTAssertEqual(widgets2.count, 3)
        XCTAssertEqual(widgets2[0].backgroundColor?.toHexString(), "#f7f7f7")
        XCTAssertEqual(widgets2[1].backgroundColor?.toHexString(), "#ffff00")
        XCTAssertEqual(widgets2[2].backgroundColor?.toHexString(), "#0000ff")
        
        // Проверяем что средний виджет заменился, а первый и последний остались теми же самыми
        XCTAssertTrue(widgets1[0] === widgets2[0])
        XCTAssertTrue(widgets1[1] !== widgets2[1])
        XCTAssertTrue(widgets1[2] === widgets2[2])
    }
    
    // MARK: HELPERS
    
    private func makeSut() -> (RootWidget, WidgetLoaderStub) {
        let loader = WidgetLoaderStub()
        let root = TestScreenComposer.compose(loader: loader) as! RootWidget
        return (root, loader)
    }
}

extension TestWidgetReplacement {
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
        "empty2",
        "empty4"
    ],
    "children": [
        {
            "type": "EMPTY",
            "instance": "empty1",
            "data": {
                "color": "#f7f7f7"
            }
        },
        {
            "type": "EMPTY",
            "instance": "empty2",
            "data": {
                "color": "#ffff00"
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
