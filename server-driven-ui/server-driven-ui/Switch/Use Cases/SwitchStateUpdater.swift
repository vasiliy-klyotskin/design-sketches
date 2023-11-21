//
//  SwitchStateUpdater.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

// TODO: Возможно компоненты обновления стейта перенесутся ближе к SDUI, пока не знаю
// TODO: Вынести абстракцию стореджа

final class SwitchStateUpdater {
    private let id: WidgetInstanceId
    private let storage: InMemoryWidgetDataStorage
    private let encoder: JSONEncoder
    private var lastModel: SwitchModel?
    
    init(id: WidgetInstanceId, storage: InMemoryWidgetDataStorage) {
        self.id = id
        self.storage = storage
        self.encoder = JSONEncoder()
    }
    
    func updateStateForOn() {
        updateStateFor(isOn: true)
    }
    
    func updateStateForOff() {
        updateStateFor(isOn: false)
    }
    
    func updateLast(model: SwitchModel) {
        lastModel = model
    }
    
    private func updateStateFor(isOn: Bool) {
        guard let lastModel else { return }
        let newModel = lastModel.new(isOn: isOn)
        let dto = SwitchDTO.from(model: newModel)
        guard let widgetData = try? encoder.encode(dto) else { return }
        storage.update(widgetData, for: id)
    }
}
