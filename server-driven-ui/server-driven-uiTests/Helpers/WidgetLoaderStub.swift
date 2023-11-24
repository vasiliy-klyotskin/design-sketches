//
//  WidgetLoaderStub.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 23.11.2023.
//

import Foundation
import UIKit
@testable import server_driven_ui

class WidgetLoaderStub: WidgetLoader {
    var json: String?
    
    func loadWidget(completion: (WidgetHeirarchy) -> Void) {
        if let data = json?.data(using: .utf8) {
            do {
                let dto = try JSONDecoder().decode(WidgetDTO.self, from: data)
                completion(WidgetDTOMapper.heirarchy(from: dto))
            } catch {
                print(error)
                completion(.empty)
            }
        } else {
            completion(.empty)
        }
    }
}
