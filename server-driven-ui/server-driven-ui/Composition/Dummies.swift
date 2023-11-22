//
//  Dummies.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct ExampleLoader: WidgetLoader {
    private let decoder = JSONDecoder()
    
    func loadWidget(completion: (WidgetHeirarchy) -> Void) {
        let dto = try! decoder.decode(WidgetDTO.self, from: json.data(using: .utf8)!)
        let heirarchy = WidgetDTOMapper.heirarchy(from: dto)
        completion(heirarchy)
    }
    
    let json =
    """
    {
        "type": "STACK",
        "instance": "0",
        "data": {
            "spacing": 10
        },
        "children": [
            {
                "type": "LABEL",
                "instance": "1",
                "data": {
                    "text": "Some title"
                }
            },
            {
                "type": "BUTTON",
                "instance": "2",
                "data": {
                    "title": "Press me"
                },
                "actions": [
                    {
                        "type": "PRINT_CONSOLE",
                        "intent": "BUTTON_TAP",
                        "data": {
                            "text": "Hello World!!!"
                        }
                    }
                ]
            }
        ]
    }
    """

}
