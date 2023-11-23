//
//  StackPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

protocol StackView {
    associatedtype Child
    func insert(child: Child, at index: Int)
    func delete(at index: Int)
}

final class StackPresenter<View: StackView> {
    typealias ChildId = AnyHashable

    private let view: View
    
    init(view: View) {
        self.view = view
    }
    
    func present(
        previous: LinearPositioning?,
        current: LinearPositioning,
        children: [ChildId: View.Child]
    ) {
        let diff = current.difference(for: previous)
        for deletion in diff.deletions {
            view.delete(at: deletion.index)
        }
        for insertion in diff.insertions {
            guard let child = children[insertion.element] else { continue }
            view.insert(child: child, at: insertion.index)
        }
    }
}
