//
//  WidgetsModelStoreFake.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/17/23.
//

@testable import server_driven_ui
//
//final class WidgetsModelStoreFake {
//    private var labelModels: [WidgetInstanceId: LabelModel] = [:]
//    private var stackModels: [WidgetInstanceId: WidgetStackModel] = [:]
//    
//    func getLabelModel(with id: WidgetId) -> LabelModel {
//        labelModels[id.instance] ?? .init(text: "default text")
//    }
//    
//    func getStackModel(with id: WidgetId) -> WidgetStackModel {
//        stackModels[id.instance] ?? .init()
//    }
//    
//    func update(_ model: LabelModel, for id: WidgetInstanceId) {
//        labelModels[id] = model
//    }
//    
//    func update(_ model: WidgetStackModel, for id: WidgetInstanceId) {
//        stackModels[id] = model
//    }
//}
