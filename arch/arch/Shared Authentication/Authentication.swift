//
//  Authentication.swift
//  arch
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

enum AuthChecker {
    struct UserNotAuthorized: Error {}
    
    static func checkAuth() throws {
        throw UserNotAuthorized()
    }
}
