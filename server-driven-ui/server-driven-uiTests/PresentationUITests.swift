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
        let (sut, view) = try makeSut()
        
        // Выводим три виджета: 1, 3, 4
        let model = firstModel()
        sut(model)

        // Проверяем что виджеты появились на экране
        sut.presenter!.assertIsDisplayingWidgetViews(
            [EmptyWidget1View.self, EmptyWidget3View.self, EmptyWidget4View.self]
        )
        let widgetViews1 = sut.presenter!.widgetViews
        
        // Проверяем цвета виджетов
        XCTAssertEqual(widgetViews1[0].backgroundColor, .red)
        XCTAssertEqual(widgetViews1[1].backgroundColor, .green)
        XCTAssertEqual(widgetViews1[2].backgroundColor, .blue)

        // Выводим три виджета: 1, 2, 4
        sut.accept(
            model: ScrollViewModel(scrollingDirection: .vertical),
            children: makeStack([
                EmptyWidget1(model: .gray),
                EmptyWidget2(model: .yellow),
                EmptyWidget4(model: .blue),
            ])
        )
        waitForLayoutPass()
        
        // Проверяем что виджеты поменяли свой состав,
        // то есть EmptyWidget3View был удален а EmptyWidget2View - вставлен на его место
        sut.presenter!.assertIsDisplayingWidgetViews(
            [EmptyWidget1View.self, EmptyWidget2View.self, EmptyWidget4View.self]
        )
        let widgetViews2 = sut.presenter!.widgetViews

        // Проверяем что первый виджет поменял свой цвет
        XCTAssertEqual(widgetViews2[0].backgroundColor, .gray)
        XCTAssertEqual(widgetViews2[1].backgroundColor, .yellow)
        XCTAssertEqual(widgetViews2[2].backgroundColor, .blue)

        // Проверяем что средний виджет заменился, а первый и последний остались теми же самыми
        XCTAssertTrue(widgetViews1[0] === widgetViews2[0])
        XCTAssertTrue(widgetViews1[1] !== widgetViews2[1])
        XCTAssertTrue(widgetViews1[2] === widgetViews2[2])
    }
    
    
    typealias SUT = (WidgetDifference) -> Void
    typealias SutView = RootWidget
    
    private func makeSut() -> (SUT, SutView) {
        let root = RootWidget()
        let registry = UIKitWidgetCoordinatorRegistry(coordinatorFactory: Self.coordinatorFactory(root: root))
        let sut = {
            let viewModel = WidgetDifferencePresenter.present(widgetDifference: $0)
            registry.coordinate(viewModel: viewModel)
        }
        return (sut, root)
    }
    
    private static func coordinatorFactory(root: RootWidget) -> (WidgetTypeId) -> UIKitWidgetCoordinator {{ typeId in
        let factories: [WidgetTypeId: () -> UIKitWidgetCoordinator] = [
            "ROOT": { RootWidgetCoordinator(root: root) },
            "STACK": { StackViewUIKitCoordinator(factory: stackWidgetFactory, getModel: { _ in .init() }) },
            "LABEL": { LabelUIKitCoordinator(factory: labelWidgetFactory, getModel: { _ in .init() }) }
        ]
        return factories[typeId]!()
    }}
    
    private static func stackWidgetFactory(model: WidgetStackModel) -> WidgetStackView {
        
    }
    
    private static func labelWidgetFactory(model: LabelModel) -> LabelWidget {
        
    }
    
    private func firstModel() -> WidgetDifference {
        .init(
            new: .init(
                widgets: [
                    0: .init(id: .init(type: "STACK", instance: "STACK_0", state: 0), parent: "root", children: [1, 3, 4]),
                    1: .init(id: .init(type: "LABEL", instance: "LABEL_0", state: "any"), parent: 0, children: []),
                    3: .init(id: .init(type: "LABEL", instance: "LABEL_1", state: "any"), parent: 0, children: []),
                    4: .init(id: .init(type: "LABEL", instance: "LABEL_2", state: "any"), parent: 0, children: [])
                ],
                rootId: 0
            ),
            old: .empty
        )
    }
}
