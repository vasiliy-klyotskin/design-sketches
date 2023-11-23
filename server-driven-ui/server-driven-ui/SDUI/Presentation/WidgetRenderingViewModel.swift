//
//  WidgetRenderingViewModel.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/16/23.
//

import Foundation

struct WidgetRenderingViewModel {
    let creations: [Creation]
    let deletions: [Deletion]
    let updates: [Update]
    let positioning: [Positioning]
    
    struct Creation {
        let id: WidgetId
        let data: WidgetData
    }
    
    struct Deletion {
        let id: WidgetId
    }
    
    struct Update {
        let id: WidgetId
        let data: WidgetData
    }
    
    struct Positioning {
        let id: WidgetId
        let positioningChanges: PositioningChanges
    }
    
    struct PositioningChanges {
        let old: PositioningChange?
        let new: PositioningChange
    }
    
    struct PositioningChange {
        let positioning: WidgetPositioning
        let children: [WidgetInstanceId]
    }
}
