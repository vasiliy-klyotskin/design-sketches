//
//  WidgetMapper.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

enum WidgetDTOMapper {
    static func heirarchy(from dto: WidgetDTO) -> WidgetHeirarchy {
        var widgetMap: [WidgetInstanceId: Widget] = [:]
        let encoder = JSONEncoder()
        let rootId = AnyHashable(dto.instance)
        buildWidget(from: dto, parent: nil)
        return WidgetHeirarchy(widgets: widgetMap, rootId: rootId)
        
        func buildWidget(from dto: WidgetDTO, parent: WidgetInstanceId?) {
            let childrenIds = dto.children?.map { $0.instance } ?? []
            let parent = parent ?? AnyHashable(dto.instance)
            let data = try! encoder.encode(dto.data)
            let actions: [Action] = dto.actions?.map {
                let actionData = try! encoder.encode($0.data)
                return Action(intent: $0.intent, type: $0.type, data: actionData)
            } ?? []
            let widgetId = WidgetId(
                type: dto.type,
                instance: dto.instance,
                state: dto.data
            )
            
            widgetMap[widgetId.instance] = Widget(
                id: widgetId,
                parent: parent,
                children: childrenIds,
                data: data,
                actions: actions
            )

            dto.children?.forEach {
                buildWidget(from: $0, parent: widgetId.instance)
            }
        }
    }
}
