//
//  UpdateWidgetContentInteractor.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

protocol WidgetLoader {
    func loadWidget(completion: (WidgetHeirarchy) -> Void)
}

// TODO: Возможно стоит разделить юз кейсы в этом классе

class WidgetsInteractor {
    private let loader: WidgetLoader
    private let presenter: WidgetDifferencePresenter
    private let storage: InMemoryWidgetDataStorage
    
    private var lastHeirarchy: WidgetHeirarchy
    
    init(
        loader: WidgetLoader,
        presenter: WidgetDifferencePresenter,
        storage: InMemoryWidgetDataStorage
    ) {
        self.presenter = presenter
        self.storage = storage
        self.loader = loader
        self.lastHeirarchy = .empty
    }
    
    func beginLoadingNewWidget() {
        loader.loadWidget { newHeirarchy in
            rerenderFor(heirarchy: newHeirarchy)
        }
    }
    
    func rerenderContent() {
        let newestHeirarchy = WidgetHeirarchy.init(rootedWidgets: storage.getWidgets()) ?? .empty
        rerenderFor(heirarchy: newestHeirarchy)
    }
    
    private func rerenderFor(heirarchy: WidgetHeirarchy) {
        let difference = WidgetDifference(new: heirarchy, old: lastHeirarchy)
        presenter.present(widgetDifference: difference)
        lastHeirarchy = heirarchy
    }
}
