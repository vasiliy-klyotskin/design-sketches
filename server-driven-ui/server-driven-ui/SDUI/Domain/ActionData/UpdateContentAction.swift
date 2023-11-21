//
//  UpdateContentAction.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct UpdateContentAction {
    let updations: [(WidgetInstanceId, WidgetData)]
    let deletions: [WidgetInstanceId]
}
