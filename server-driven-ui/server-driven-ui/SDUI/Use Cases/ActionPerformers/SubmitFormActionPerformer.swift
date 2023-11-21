//
//  SubmitFormActionPerformer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

typealias SubmitHandler = (URL, [WidgetInstanceId: WidgetData]) -> Void

class SubmitFormActionPerformer {
    let action: SubmitFormAction
    let storage: InMemoryWidgetDataStorage
    let submit: SubmitHandler
    
    init(
        action: SubmitFormAction,
        storage: InMemoryWidgetDataStorage,
        submit: @escaping SubmitHandler
    ) {
        self.storage = storage
        self.action = action
        self.submit = submit
    }
    
    func perform() {
        var dataToSubmit = [WidgetInstanceId: WidgetData]()
        for id in action.ids {
            guard let data = storage.getWidgetData(for: id) else { continue }
            dataToSubmit[id] = data
        }
        submit(action.url, dataToSubmit)
    }
}
