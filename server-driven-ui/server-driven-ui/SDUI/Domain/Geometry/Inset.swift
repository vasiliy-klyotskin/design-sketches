//
//  Inset.swift
//  server-driven-ui
//
//  Created by Марина Чемезова on 23.11.2023.
//

import Foundation

/// Дубликат UIEdgeInset, не привязанный к UIKit
public struct Inset : @unchecked Sendable {
    public init() {
        self.init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    public var top: CGFloat // specify amount to inset (positive) for each of the edges. values can be negative to 'outset'

    public var leading: CGFloat

    public var bottom: CGFloat

    public var trailing: CGFloat
}

public extension Inset {
    static var zero: Inset { Inset() }
}

extension Inset: Codable { }
extension Inset: Hashable { }
