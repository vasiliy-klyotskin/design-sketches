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
}
    
    let json =
"""
    {
        "type": "STACK",
        "instance": "0",
        "data": {
            "spacing": 10
        },
        "positioning": {
            "1": 0,
            "2": 1,
            "7": 2,
            "5": 3
        },
        "children": [
            {
                "type": "LABEL",
                "instance": "2",
                "data": {
                    "text": "Don't you mind to add a widget?"
                }
            },
            {
                "type": "LABEL",
                "instance": "1",
                "data": {
                    "text": "How's it going buddy?"
                }
            },
            {
                "type": "LABEL",
                "instance": "5",
                "data": {
                    "text": "Hey!!!"
                }
            },
            {
                "type": "LABEL",
                "instance": "7",
                "data": {
                    "text": "What's up?"
                }
            }
        ]
    }
"""


//let json =
//"""
//{
//    "type": "STACK",
//    "instance": "0",
//    "data": {
//        "spacing": 10
//    },
//    "children": [
//        {
//            "type": "LABEL",
//            "instance": "1",
//            "data": {
//                "text": "How's it going buddy?"
//            }
//        },
//        {
//            "type": "LABEL",
//            "instance": "2",
//            "data": {
//                "text": "Don't you mind to add a widget?"
//            }
//        },
//        {
//            "type": "SWITCH",
//            "instance": "3",
//            "data": {
//                "isOn": false,
//                "isDisabled": false
//            },
//            "actions": [
//                {
//                    "type": "LOCAL_UPDATE",
//                    "intent": "SWITCH_ON",
//                    "data": {
//                        "insertions": [
//                            {
//                                "widget": {
//                                    "type": "LABEL",
//                                    "instance": "5",
//                                    "data": {
//                                        "text": "Here we go!"
//                                    }
//                                },
//                                "parentInstanceId": "0",
//                                "index": 2
//                            }
//                        ]
//                    }
//                },
//                {
//                    "type": "LOCAL_UPDATE",
//                    "intent": "SWITCH_OFF",
//                    "data": {
//                        "removals": [
//                            "5"
//                        ]
//                    }
//                }
//            ]
//        },
//        {
//            "type": "BUTTON",
//            "instance": "4",
//            "data": {
//                "title": "Press me to log something to your console"
//            },
//            "actions": [
//                {
//                    "type": "PRINT_CONSOLE",
//                    "intent": "BUTTON_TAP",
//                    "data": {
//                        "text": "Hello World!!!"
//                    }
//                },
//
//                {
//                    "type": "SUBMIT_FORM",
//                    "intent": "BUTTON_TAP",
//                    "data": {
//                        "url"
//                        "instanceIds"
//                    }
//                },
//                {
//                    "type": "AUTH",
//                    "intent": "BUTTON_TAP",
//                    "data": {
//                        
//                        
//                    }
//                }
//            ]
//        }
//    ]
//}
//"""
