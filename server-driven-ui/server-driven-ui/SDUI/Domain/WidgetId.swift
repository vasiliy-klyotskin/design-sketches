//
//  WidgetId.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

/// Идентификатор виджета
///
/// Содержит информацию и типе, уникальный идентификатор виджета и идентификатор его состояния.
/// Используется как ключ в хэш таблицах и как идентификатор для построения разницы виджет-деревьев.
struct WidgetId {
    /// Идентификатор типа виджета. Чаще всего это просто строка
    let type: WidgetTypeId
    
    /// Идентификатор экземпляра виджета. Чаще всего это просто строка
    let instance: WidgetInstanceId
    
    /// Идентификатор состояния виджета
    let state: WidgetStateId
    
    // TODO: Documentation
    let positioning: WidgetPositioningId
    
    // TODO: Documentation
    static var positioningIdForNotContainers: WidgetPositioningId {
        "NO_POSITIONING"
    }
    
    // TODO: Documentation
    static var rootContainerKeyForIds: String {
        "ROOT_CONTAINER"
    }
}
