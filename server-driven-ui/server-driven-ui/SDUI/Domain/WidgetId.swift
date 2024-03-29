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
    
    /// Идентификатор состояния виджета. По нему мы поимаем, когда мы хотим обновить данные для определенного виджета
    let state: WidgetStateId
    
    /// Идентификатор позиционирования виджета. Если у виджетов с одним и тем же инстансом отличаются positioning, то мы хотим перепозиционировать детей в последнем
    let positioning: WidgetPositioningId
    
    /// Идентификатор дляпозиционирования для тех виджетов, которые не являются контейнерами
    static var positioningIdForNotContainers: WidgetPositioningId {
        "NO_POSITIONING"
    }
    
    /// Идентификатор для искусственно добавляемого корневого контейнера.
    static var rootContainerKeyForIds: String {
        "ROOT_CONTAINER"
    }
}
