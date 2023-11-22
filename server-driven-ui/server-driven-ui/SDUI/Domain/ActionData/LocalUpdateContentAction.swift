//
//  UpdateContentAction.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct LocalUpdateContentAction {
    let insertions: [Insertion]
    let updates: [Update]
    let removals: [WidgetInstanceId]
    
    struct Insertion {
        let heirarchy: WidgetHeirarchy
        let index: Int
        let parentInstanceId: WidgetInstanceId
    }
    
    struct Update {
        let instanceId: WidgetInstanceId
        let data: WidgetData
    }
}
