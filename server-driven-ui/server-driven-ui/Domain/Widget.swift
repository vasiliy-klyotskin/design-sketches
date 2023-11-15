//
//  Widget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

typealias WidgetTypeId = AnyHashable
typealias WidgetInstanceId = AnyHashable
typealias WidgetStateId = AnyHashable

struct Widget {
    let id: WidgetId
    let children: [Widget]
}

struct WidgetId {
    let type: WidgetTypeId
    // беку достаточно присылать разные instanceId для разных виджетов с точки зрения бизнеса. Например, если в стеке два лейбла, то бек точно знает как сгенерить айдишники так, чтоб при повторном запросе instanceId остались теми же для тех же лейблов
    let instance: WidgetInstanceId
    let state: WidgetStateId
}

struct WidgetDifference {
    let new: Widget
    let old: Widget
    
    var widgetsAreWithDifferentType: Bool {
        new.id.type != old.id.type
    }
    
    var widgetsAreWithDifferentInstance: Bool {
        new.id.type == old.id.type &&
        new.id.instance != old.id.instance
    }
    
    var widgetsAreWithDifferentState: Bool {
        new.id.type == old.id.type &&
        new.id.instance == old.id.instance &&
        new.id.state != old.id.state
    }
    
    var widgetsHaveTheSameIdentity: Bool {
        new.id.type == old.id.type &&
        new.id.instance == old.id.instance &&
        new.id.state == old.id.state
    }
}
