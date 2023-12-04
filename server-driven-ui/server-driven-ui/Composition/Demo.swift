//
//  Dummies.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation
import UIKit

class DemoLoader: WidgetLoader {
    private let decoder = JSONDecoder()
    var count = 0
    
    func loadWidget(completion: @escaping (WidgetHeirarchy) -> Void) {
        let json = count % 2 == 1 ? json1 : json2
        count += 1
        let dto = try! decoder.decode(WidgetDTO.self, from: json.data(using: .utf8)!)
        let heirarchy = WidgetDTOMapper.heirarchy(from: dto)
        completion(heirarchy)
    }
}

extension DemoLoader {
    var json1: String {
"""
{
    "type": "SCROLL",
    "instance": "scroll",
    "data": { },
    "positioning": "stack",
    "children": [
        {
            "type": "STACK",
            "instance": "stack",
            "data": {
                "spacing": 10
            },
            "positioning": [
                "empty1",
                "empty3",
                "empty4",
                "empty5",
                "empty6",
                "empty7",
                "empty8",
                "empty9",
            ],
            "children": [
                {
                    "type": "EMPTY",
                    "instance": "empty1",
                    "data": {
                        "color": "#ff0000",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty3",
                    "data": {
                        "color": "#00ff00",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty4",
                    "data": {
                        "color": "#0000ff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty5",
                    "data": {
                        "color": "#ffff00",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty6",
                    "data": {
                        "color": "#ff00ff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty7",
                    "data": {
                        "color": "#ababff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty8",
                    "data": {
                        "color": "#00ffff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty9",
                    "data": {
                        "color": "#7f7f7f",
                        "height": 150
                    }
                },
            ]
        }
    ]
}
"""
    }
    
    var json2: String {
"""
{
    "type": "SCROLL",
    "instance": "scroll",
    "data": { },
    "positioning": "stack",
    "children": [
        {
            "type": "STACK",
            "instance": "stack",
            "data": {
                "spacing": 10
            },
            "positioning": [
                "empty3",
                "empty1",
                "scroll2",
                "empty4",
                "empty5",
                "empty6",
                "empty7",
                "empty8",
                "empty9",
            ],
            "children": [
                {
                    "type": "EMPTY",
                    "instance": "empty1",
                    "data": {
                        "color": "#999999",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty3",
                    "data": {
                        "color": "#00ff00",
                        "height": 150
                    }
                },
                {
                    "type": "SCROLL",
                    "instance": "scroll2",
                    "data": { "direction": "horizontal" },
                    "positioning": "stack1",
                    "children": [
                        {
                            "type": "STACK",
                            "instance": "stack1",
                            "data": {
                                "spacing": 10,
                                "axis": "horizontal"
                            },
                            "positioning": [
                                "empty11",
                                "empty13",
                                "empty14",
                                "empty15",
                                "empty16",
                                "empty17",
                                "empty18",
                                "empty19",
                            ],
                            "children": [
                                {
                                    "type": "EMPTY",
                                    "instance": "empty11",
                                    "data": {
                                        "color": "#ff0000",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty13",
                                    "data": {
                                        "color": "#00ff00",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty14",
                                    "data": {
                                        "color": "#0000ff",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty15",
                                    "data": {
                                        "color": "#ffff00",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty16",
                                    "data": {
                                        "color": "#ff00ff",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty17",
                                    "data": {
                                        "color": "#ababff",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty18",
                                    "data": {
                                        "color": "#00ffff",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                                {
                                    "type": "EMPTY",
                                    "instance": "empty19",
                                    "data": {
                                        "color": "#7f7f7f",
                                        "width": 80,
                                        "height": 150
                                    }
                                },
                            ]
                        }
                    ]
                },
                {
                    "type": "EMPTY",
                    "instance": "empty4",
                    "data": {
                        "color": "#0000ff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty5",
                    "data": {
                        "color": "#ffff00",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty6",
                    "data": {
                        "color": "#ff00ff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty7",
                    "data": {
                        "color": "#ababff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty8",
                    "data": {
                        "color": "#00ffff",
                        "height": 150
                    }
                },
                {
                    "type": "EMPTY",
                    "instance": "empty9",
                    "data": {
                        "color": "#7f7f7f",
                        "height": 150
                    }
                },
            ]
        }
    ]
}
"""
    }
}
