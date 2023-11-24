//
//  Inset+UIEdgeInset.swift
//  server-driven-ui
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit

public extension Inset {
    var edgeInset: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
}
