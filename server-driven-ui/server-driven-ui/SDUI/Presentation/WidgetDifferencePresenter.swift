//
//  WidgetPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

protocol WidgetDifferenceView {
    func display(viewModel: WidgetDifferenceViewModel)
}

/// Рассчитывет разницу двух деревьев виджетов и передает результат в ``WidgetDifferenceView``
///
/// Для обновления структуры дерева виджетов используется дифференциальный алгоритм,
/// который рассчитывает изменения, необходимые для того чтобы преобразовать старую версию
/// иерархии виджетов в новую.
///
/// Изменения включают в себя три операции:
/// - удаление ненужных элементов дерева
/// - вставка новых элементов дерева
/// - обновление данных в тех элементах, у которых не совпадают данные
///
/// ``WidgetDifferencePresenter`` принимает на вход две иерархии виджетов и выполняет расчет изменений.
/// Результат расчета передается в ``WidgetDifferenceView`` для непосредственной модификации UI
final class WidgetDifferencePresenter {
    private let view: WidgetDifferenceView
    
    /// Создает WidgetDifferencePresenter
    init(view: WidgetDifferenceView) {
        self.view = view
    }
    
    /// Рассчитывает разницу между иерархиями виджетов, содержащихся в ``WidgetDifference`` и передает результат в ``WidgetDifferenceView``, переданный в конструкторе
    func present(widgetDifference diff: WidgetDifference) {
        let (deletions, insertions) = deletionsAndInsertions(from: diff)
        let updates = updates(from: diff)
        view.display(viewModel: .init(
            deletions: deletions,
            insertions: insertions,
            updates: updates
        ))
    }

    private func deletionsAndInsertions(from diff: WidgetDifference) -> (WidgetDeletionsViewModel, WidgetInsertionsViewModel) {
        let oldPairs = diff.old.allPairsBreadthFirst
        let newPairs = diff.new.allPairsBreadthFirst
        let difference = newPairs.difference(from: oldPairs)
        let deletionsViewModel = diff.deletionsViewModel(from: difference.removals)
        let insertionsViewModel = diff.insertionsViewModel(from: difference.insertions, heirarchy: diff.new)
        return (deletionsViewModel, insertionsViewModel)
    }
    
    private func updates(from diff: WidgetDifference) -> WidgetUpdatesViewModel {
        diff.old.widgets.compactMap { (instanceId, oldWidget) in
            diff.new.widgets[instanceId].flatMap { newWidget in
                newWidget.isDifferentState(from: oldWidget) ? (newWidget.id, newWidget.data) : nil
            }
        }
    }
}
