//
//  TopLeftBottomPositioning.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

struct TopLeftBottomPositioning {
    typealias ChildId = AnyHashable
    
    let top: ChildId?
    let left: ChildId?
    let bottom: ChildId?
}
