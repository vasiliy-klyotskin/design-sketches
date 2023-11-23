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

class WidgetsInteractor {
    private let loader: WidgetLoader
    private let presenter: WidgetRenderingPresenter
    private let storage: InMemoryWidgetDataStorage
    
    private var lastHeirarchy: WidgetHeirarchy
    
    init(
        loader: WidgetLoader,
        presenter: WidgetRenderingPresenter,
        storage: InMemoryWidgetDataStorage
    ) {
        self.presenter = presenter
        self.storage = storage
        self.loader = loader
        self.lastHeirarchy = .empty
    }
    
    func beginLoadingNewWidgetInitialy() {
        beginLoadingNewWidget(with: [:])
    }
    
    func beginLoadingNewWidget(with data: [WidgetInstanceId: WidgetData]) {
        loader.loadWidget { newHeirarchy in
            let heirarchyWithContainer = newHeirarchy.wrappedIntoRootContainer
            storage.update(with: heirarchyWithContainer)
            rerenderFor(heirarchy: heirarchyWithContainer)
        }
    }
    
    func rerenderContent() {
        let newestHeirarchy = storage.getHeirarchy()
        rerenderFor(heirarchy: newestHeirarchy)
    }
    
    private func rerenderFor(heirarchy: WidgetHeirarchy) {
        let difference = WidgetDifference(new: heirarchy, old: lastHeirarchy)
        presenter.present(widgetDifference: difference)
        lastHeirarchy = heirarchy
    }
}
