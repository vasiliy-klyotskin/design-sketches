//
//  UIImage+Creation.swift
//  OrderTrackingTests
//
//  Created by Василий Клецкин on 15.02.2023.
//

import UIKit

public extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
         format.scale = 1
         return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
             color.setFill()
             rendererContext.fill(rect)
         }
    }
}
