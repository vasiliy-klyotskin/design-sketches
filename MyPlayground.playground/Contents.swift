import UIKit

var greeting = "Hello, playground"

struct P: Equatable {
    let f: Int
    let s: Int
    
    init(_ f: Int, _ s: Int) {
        self.f = f
        self.s = s
    }
}

let array1 = [P(-1, 0)]
let array2 = [P(-1, 1)]




let differences = array2.difference(from: array1)

for change in differences {
    switch change {
    case .insert(offset: let offset, element: let element, associatedWith: _):
        print("Insert \(element) at index \(offset)")
    case .remove(offset: let offset, element: let element, associatedWith: _):
        print("Remove \(element) at index \(offset)")
    }
}



import Foundation

typealias WidgetTypeId = AnyHashable
typealias WidgetInstanceId = AnyHashable
typealias WidgetStateId = AnyHashable

struct WidgetId {
    let type: WidgetTypeId
    let instance: WidgetInstanceId
    let state: WidgetStateId
}

struct Widget {
    let id: WidgetId
    let parent: WidgetInstanceId
    let children: [WidgetInstanceId]
    
    func isDifferentType(from other: Widget) -> Bool {
        id.type != other.id.type
    }
    
    func isDifferentInstance(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance != other.id.instance
    }
    
    func isDifferentState(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state != other.id.state
    }
    
    func hasTheSameIdentity(as other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state == other.id.state
    }
}

struct WidgetHeirarchy {
    let widgets: [WidgetInstanceId: Widget]
    
    var root: Widget {
        widgets["root"]!
    }
    
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    init(widgets: [WidgetInstanceId : Widget]) {
        self.widgets = widgets
    }
    
    var allPairsBreadthFirst: [WidgetPair] {
        var result: [WidgetPair] = []
        var queue: [(offset: Int, element: Widget)] = [(0, root)]
        
        while let (index, widget) = queue.first {
            queue.removeFirst()
            result.append(.withParent(widget, indexInParent: index))
            queue.append(contentsOf: widget.children.compactMap { widgets[$0] }.enumerated())
        }
        return result
    }
}

struct WidgetDifference {
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
}

struct WidgetPair: Equatable {
    let parent: WidgetInstanceId
    let child: WidgetInstanceId
    let childIndexInParent: Int
    
    static func withParent(_ widget: Widget, indexInParent: Int) -> WidgetPair {
        .init(parent: widget.parent, child: widget.id.instance, childIndexInParent: indexInParent)
    }
}

struct WidgetDifferenceViewModel {
    let deletions: WidgetDeletionsViewModel
    let insertions: WidgetInsertionsViewModel
    let updates: WidgetUpdatesViewModel
}

typealias WidgetDeletionsViewModel = [(childId: WidgetId, parentId: WidgetId, index: Int)]
typealias WidgetInsertionsViewModel = [(childId: WidgetId, parentId: WidgetId, index: Int)]
typealias WidgetUpdatesViewModel = [WidgetId]

protocol WidgetDifferencePresenterDelegate {
    func coordinate(viewModel: WidgetDifferenceViewModel)
}

final class WidgetDifferencePresenter {
    func present(widgetDifference diff: WidgetDifference) -> WidgetDifferenceViewModel {
        let (deletions, insertions) = deletionsAndInsertions(from: diff)
        let updates = updates(from: diff)
        return .init(deletions: deletions, insertions: insertions, updates: updates)
    }

    private func deletionsAndInsertions(from diff: WidgetDifference) -> (WidgetDeletionsViewModel, WidgetInsertionsViewModel) {
        let oldPairs = diff.old.allPairsBreadthFirst
        let newPairs = diff.new.allPairsBreadthFirst
        let difference = newPairs.difference(from: oldPairs)
        let deletionsViewModel = diff.deletionsViewModel(from: difference.removals)
        let insertionsViewModel = diff.insertionsViewModel(from: difference.insertions)
        return (deletionsViewModel, insertionsViewModel)
    }
    
    private func updates(from diff: WidgetDifference) -> WidgetUpdatesViewModel {
        diff.old.widgets.compactMap { (instanceId, oldWidget) in
            diff.new.widgets[instanceId].flatMap { newWidget in
                newWidget.isDifferentState(from: oldWidget) ? newWidget.id : nil
            }
        }
    }
}


extension WidgetDifference {
    func deletionsViewModel(from removals: [CollectionDifference<WidgetPair>.Change]) -> WidgetDeletionsViewModel {
        removals.compactMap {
            switch $0 {
            case .remove(_, let element, _):
                guard let child = old.widgets[element.child] else { return nil }
                guard let parent = old.widgets[element.parent] else { return nil }
                return (childId: child.id, parentId: parent.id, index: element.childIndexInParent)
            default: return nil
            }
        }
    }
    
    func insertionsViewModel(from insertions: [CollectionDifference<WidgetPair>.Change]) -> WidgetInsertionsViewModel {
        insertions.compactMap {
            switch $0 {
            case .insert(_, let element, _):
                guard let child = new.widgets[element.child] else { return nil }
                guard let parent = new.widgets[element.parent] else { return nil }
                return (childId: child.id, parentId: parent.id, index: element.childIndexInParent)
            default: return nil
            }
        }
    }
}





let diff = WidgetDifference(
    new: .init(widgets: [
        "root": .init(id: .init(type: "root", instance: "root", state: "root"), parent: "root", children: [0]),
        0: .init(id: .init(type: "any", instance: 0, state: "any"), parent: "root", children: [])
    ]),
    old: .init(widgets: [
        "root": .init(id: .init(type: "root", instance: "root", state: "root"), parent: "root", children: [1]),
        1: .init(id: .init(type: "any", instance: 1, state: "any"), parent: "root", children: [])
    ])
)

//let diff = WidgetDifference(
//    new: .init(widgets: [
//        "root": .init(id: .init(type: "root", instance: "root", state: "root"), parent: "root", children: [1]),
//        1: .init(id: .init(type: "any", instance: 1, state: "any1"), parent: "root", children: [])
//    ]),
//    old: .init(widgets: [
//        "root": .init(id: .init(type: "root", instance: "root", state: "root"), parent: "root", children: [1]),
//        1: .init(id: .init(type: "any", instance: 1, state: "any"), parent: "root", children: [])
//    ])
//)
let result = WidgetDifferencePresenter().present(widgetDifference: diff)
print(result)
print(result.deletions.count, "deletions")
print(result.insertions.count, "insertions")
