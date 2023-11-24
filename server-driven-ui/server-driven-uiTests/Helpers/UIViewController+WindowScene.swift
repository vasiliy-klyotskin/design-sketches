//
//  UIViewController+WindowScene.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 24.11.2023.
//

import UIKit

extension UIViewController {
    func attachToScreen() throws {
        let window = SnapshotWindow(configuration: .default(style: .light), root: self)
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw NSError(domain: "Failed to find window scene to attach window", code: 1)
        }
        window.windowScene = scene
        window.isHidden = false
    }
}
