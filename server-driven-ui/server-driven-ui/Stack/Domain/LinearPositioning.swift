//
//  StackPositioning.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

// MARK: Мы можем трактовать этот Positioning не просто как объект описывающий позиционирование в StackView, но и как объект опизываюший позиционирование в любом контейнере, где дети расположены линейно

// TODO: Подумать над тем, чтоб хранить общие Positioning отдельно от конкретного виджета (Например, где-то в папке SDUI)

struct LinearPositioning {
    typealias ElementId = AnyHashable
    typealias IndexedElementId = (index: Int, element: ElementId)
    
    let items: [ElementId]

    func difference(for another: LinearPositioning?) -> (insertions: [IndexedElementId], deletions: [IndexedElementId])  {
        if let another {
            let diff = items.difference(from: another.items)
            let insertions = diff.insertions.compactMap {
                switch $0 {
                case .insert(let offset, let element, _):
                    return (offset, element)
                default: return nil
                }
            }
            let deletions = diff.removals.compactMap {
                switch $0 {
                case .remove(let offset, let element, _):
                    return (offset, element)
                default: return nil
                }
            }
            return (insertions, deletions)
        } else {
            let insertions = items.enumerated().map { ($0.offset, $0.element) }
            return (insertions, deletions: [])
        }
    }
}

typealias LinearPositioningDTO = [String]

extension LinearPositioningDTO {
    var model: LinearPositioning {
        .init(items: self)
    }
}
