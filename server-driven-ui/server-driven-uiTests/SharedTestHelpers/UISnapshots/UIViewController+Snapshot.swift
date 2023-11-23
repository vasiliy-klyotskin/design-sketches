//
//  UIImage+Creation.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 6/19/23.
//

import UIKit

public extension UIViewController {
	func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
		return SnapshotWindow(configuration: configuration, root: self).snapshot()
	}
}
