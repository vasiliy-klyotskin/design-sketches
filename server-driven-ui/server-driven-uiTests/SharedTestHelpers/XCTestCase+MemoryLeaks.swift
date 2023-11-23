//
//  XCTestCase+MemoryLeaks.swift
//  OrderTrackingTests
//
//  Created by Василий Клецкин on 16.02.2023.
//

import XCTest

public extension XCTestCase {
    func checkForMemoryLeaks(
        instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) supposed to be not nil. Potentially memory leak.", file: file, line: line)
        }
    }
}
