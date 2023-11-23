//
//  UIImage+Creation.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 6/19/23.
//

import XCTest

public extension XCTestCase {
    func assertDefaultSnapshot(
        sut: UIViewController,
        key: String,
        width: CGFloat = 390,
        height: CGFloat = 844,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assert(
            snapshot: sut.snapshot(for: .default(style: .light, width: width, height: height)),
            named: key + "_light",
            file: file,
            line: line
        )
        assert(
            snapshot: sut.snapshot(for: .default(style: .dark, width: width, height: height)),
            named: key + "_dark",
            file: file,
            line: line
        )
    }
    
    func recordDefaultSnapshot(
        sut: UIViewController,
        key: String,
        width: CGFloat = 390,
        height: CGFloat = 844,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        record(
            snapshot: sut.snapshot(for: .default(style: .light, width: width, height: height)),
            named: key + "_light",
            file: file,
            line: line
        )
        record(
            snapshot: sut.snapshot(for: .default(style: .dark, width: width, height: height)),
            named: key + "_dark",
            file: file,
            line: line
        )
    }
    
	func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
		let snapshotURL = makeSnapshotURL(named: name, file: file)
		let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
		
		guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
			XCTFail("Не удалось загрузить существующий снепшот для URL: \(snapshotURL). Используй \"recordDefaultSnapshot\" или \"record\" для того чтобы сохранить снепшот перед его валидацией.", file: file, line: line)
			return
		}
		
		if snapshotData != storedSnapshotData {
			let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
				.appendingPathComponent(snapshotURL.lastPathComponent)
			
			try? snapshotData?.write(to: temporarySnapshotURL)
			
			XCTFail("Новый снепшот не совпадает со старым. URL нового снепшота: \(temporarySnapshotURL), URL старого снепшота: \(snapshotURL)", file: file, line: line)
		}
	}
	
	func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
		let snapshotURL = makeSnapshotURL(named: name, file: file)
		let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
		
		do {
			try FileManager.default.createDirectory(
				at: snapshotURL.deletingLastPathComponent(),
				withIntermediateDirectories: true
			)
			
			try snapshotData?.write(to: snapshotURL)
			XCTFail("Запись снепшота \(name) прошла успешно! Теперь используй \"assertDefaultSnapshot\" или \"assert\" для валидации", file: file, line: line)
		} catch {
			XCTFail("Не удалось сохранить снепшот: \(error)", file: file, line: line)
		}
	}
	
	private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
		return URL(fileURLWithPath: String(describing: file))
			.deletingLastPathComponent()
			.appendingPathComponent("Snapshots")
			.appendingPathComponent("\(name).png")
	}
	
	private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
		guard let data = snapshot.pngData() else {
			XCTFail("Не удалось получить PNG из снапшота", file: file, line: line)
			return nil
		}
		
		return data
	}
}
