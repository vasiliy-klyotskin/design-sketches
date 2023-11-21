//
//  ActivityWidget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

final class ActivityWidget: UIActivityIndicatorView {
    func update(with model: ActivityModel) {
        if model.isActive {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
