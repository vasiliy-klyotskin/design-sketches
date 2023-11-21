//
//  SubmitFormAction.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct SubmitFormAction {
    // урл сабмита
    let url: URL
    // айдишники для которых нужны данные
    let ids: [WidgetInstanceId]
}
