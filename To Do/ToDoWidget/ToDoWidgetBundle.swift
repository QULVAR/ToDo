//
//  ToDoWidgetBundle.swift
//  ToDoWidget
//
//  Created by Вячеслав Лесной on 07.04.2024.
//

import WidgetKit
import SwiftUI

@main
struct ToDoWidgetBundle: WidgetBundle {
    var body: some Widget {
        ToDoWidget()
        ToDoWidgetLiveActivity()
    }
}
