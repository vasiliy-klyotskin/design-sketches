//
//  CoreDateStorage.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import CoreData

final class CoreDateStorage<Local, ManagedObject: NSManagedObject>: LocalStorage {
    typealias LocalMapping = (Local) -> ManagedObject
    typealias CoreDataMapping = (ManagedObject) -> (Local)
    
    private let context: NSManagedObjectContext
    private let localMapping: LocalMapping
    private let cdMapping: CoreDataMapping
    
    init(
        context: NSManagedObjectContext,
        localMapping: @escaping LocalMapping,
        cdMapping: @escaping CoreDataMapping
    ) {
        self.context = context
        self.localMapping = localMapping
        self.cdMapping = cdMapping
    }
    
    func retrieve(for key: String) throws -> (Local, Date)? {
        // performSync {
            // Вытаскиваем из контекста и мапим
        // }
        nil
    }
    
    func put(value: Local, for key: String, timestamp: Date) throws {
        // мапим
        // performSync {
            // сохраняем
        // }
    }
    
    func delete(for key: String) {
        // performSync {
            // удаляем
        // }
    }
}
