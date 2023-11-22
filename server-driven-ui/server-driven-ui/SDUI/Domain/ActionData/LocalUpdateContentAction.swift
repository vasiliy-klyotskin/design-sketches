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
        let parentInstanceId: WidgetInstanceId
        let heirarchy: WidgetHeirarchy
        let index: Int
    }
    
    struct Update {
        let instanceId: WidgetInstanceId
        let data: WidgetData
    }
}
