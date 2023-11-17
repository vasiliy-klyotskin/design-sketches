//
//  server_driven_uiTests.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/16/23.
//

import XCTest
@testable import server_driven_ui

final class server_driven_uiTests: XCTestCase {
    /// Проверяем работу умного рендеринга:
    /// 1. Выводим три виджета: 1, 3, 4
    /// 2. Выводим три виджета: 1, 2, 4
    /// Проверяем что средний виджет заменился, а первый и последний остались теми же самыми
    func test_display_replacesChangedWidgetleavingOtherIntact() throws {
        let (sut, view, store) = makeSut()
        
        // Выводим три виджета: 1, 3, 4
        let firstModel = firstDiff()
        store.update(.init(text: "text for label 1"), for: 1)
        store.update(.init(text: "text for label 3"), for: 3)
        store.update(.init(text: "text for label 4"), for: 4)
        sut(firstModel)

        // Проверяем что виджеты появились на экране
        let label1 = view.findLabel(for: 1)
        let label3 = view.findLabel(for: 3)
        let label4 = view.findLabel(for: 4)
        XCTAssertNotNil(label1)
        XCTAssertNotNil(label3)
        XCTAssertNotNil(label4)
        
        // Проверяем текст виджетов
        XCTAssertEqual(label1?.text, "text for label 1")
        XCTAssertEqual(label3?.text, "text for label 3")
        XCTAssertEqual(label4?.text, "text for label 4")

        // Выводим три виджета: 1, 2, 4
        let secondModel = secondDiff()
        store.update(.init(text: "another text for label 1"), for: 1)
        store.update(.init(text: "text for label 2"), for: 2)
        sut(secondModel)
        
        // Проверяем что виджеты поменяли свой состав,
        // то есть EmptyWidget3View был удален а EmptyWidget2View - вставлен на его место
        let newLabel1 = view.findLabel(for: 1)
        let newLabel2 = view.findLabel(for: 2)
        let newLabel3 = view.findLabel(for: 3)
        let newLabel4 = view.findLabel(for: 4)
        XCTAssertNotNil(newLabel1)
        XCTAssertNotNil(newLabel2)
        XCTAssertNil(newLabel3)
        XCTAssertNotNil(newLabel4)

        // Проверяем что первый виджет поменял свой текст
        XCTAssertEqual(newLabel1?.text, "another text for label 1")
        XCTAssertEqual(newLabel2?.text, "text for label 2")
        XCTAssertEqual(newLabel4?.text, "text for label 4")

        // Проверяем что средний виджет заменился, а первый и последний остались теми же самыми
        XCTAssertTrue(label1 === newLabel1)
        XCTAssertTrue(newLabel2 != nil)
        XCTAssertTrue(newLabel3 == nil)
        XCTAssertTrue(label4 === newLabel4)
    }
    
    // MARK: HELPERS
    
    typealias SUT = (WidgetDifference) -> Void
    typealias SutView = RootWidget
    
    private func makeSut() -> (SUT, SutView, WidgetsModelStoreFake) {
        let root = RootWidget()
        let store = WidgetsModelStoreFake()
        let coordFactory = Self.coordinatorFactory(root: root, store: store)
        let registry = UIKitWidgetCoordinatorRegistry(coordinatorFactory: coordFactory)
        let sut = {
            let viewModel = WidgetDifferencePresenter.present(widgetDifference: $0)
            registry.coordinate(viewModel: viewModel)
        }
        return (sut, root, store)
    }
    
    private static func coordinatorFactory(root: RootWidget, store: WidgetsModelStoreFake) -> (WidgetTypeId) -> UIKitWidgetCoordinator {{ typeId in
        let factories: [WidgetTypeId: () -> UIKitWidgetCoordinator] = [
            "ROOT": { RootWidgetCoordinator(root: root) },
            "STACK": { StackViewUIKitCoordinator(factory: stackWidgetFactory, getModel: store.getStackModel) },
            "LABEL": { LabelUIKitCoordinator(factory: labelWidgetFactory, getModel: store.getLabelModel) }
        ]
        return factories[typeId]!()
    }}
    
    private static func stackWidgetFactory(model: WidgetStackModel, id: WidgetId) -> WidgetStackView {
        let stack = WidgetStackView()
        // сетим тег для тестинга
        stack.tag = id.instance as! Int
        return stack
    }
    
    private static func labelWidgetFactory(model: LabelModel, id: WidgetId) -> LabelWidget {
        let label = LabelWidget(model: model)
        // сетим тег для тестинга
        label.tag = id.instance as! Int
        return label
    }
    
    private func firstDiff() -> WidgetDifference {
        .init(
            new: .init(
                widgets: [
                    0: .init(id: .init(type: "STACK", instance: 0, state: "any"), parent: "ROOT", children: [1, 3, 4]),
                    1: .init(id: .init(type: "LABEL", instance: 1, state: "first"), parent: 0, children: []),
                    3: .init(id: .init(type: "LABEL", instance: 3, state: "any"), parent: 0, children: []),
                    4: .init(id: .init(type: "LABEL", instance: 4, state: "any"), parent: 0, children: [])
                ],
                rootId: 0
            ),
            old: .empty
        )
    }
    
    
    private func secondDiff() -> WidgetDifference {
        .init(
            new: .init(
                widgets: [
                    0: .init(id: .init(type: "STACK", instance: 0, state: "any"), parent: "root", children: [1, 2, 4]),
                    1: .init(id: .init(type: "LABEL", instance: 1, state: "second"), parent: 0, children: []),
                    2: .init(id: .init(type: "LABEL", instance: 2, state: "any"), parent: 0, children: []),
                    4: .init(id: .init(type: "LABEL", instance: 4, state: "any"), parent: 0, children: [])
                ],
                rootId: 0
            ),
            old: .init(
                widgets: [
                    0: .init(id: .init(type: "STACK", instance: 0, state: "any"), parent: "root", children: [1, 3, 4]),
                    1: .init(id: .init(type: "LABEL", instance: 1, state: "first"), parent: 0, children: []),
                    3: .init(id: .init(type: "LABEL", instance: 3, state: "any"), parent: 0, children: []),
                    4: .init(id: .init(type: "LABEL", instance: 4, state: "any"), parent: 0, children: [])
                ],
                rootId: 0
            )
        )
    }
}
