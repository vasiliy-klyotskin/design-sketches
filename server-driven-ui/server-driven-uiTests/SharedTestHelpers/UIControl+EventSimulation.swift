//
//  UIControl+EventSimulation.swift
//  OrderTrackingTests
//
//  Created by Василий Клецкин on 13.02.2023.
//

import UIKit

public extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0), with: self)
            }
        }
    }
}
