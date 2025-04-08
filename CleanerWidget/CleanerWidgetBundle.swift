//
//  CleanerWidgetBundle.swift
//  CleanerWidget
//
//  Created by Elena Sedunova on 15.03.2025.
//

import WidgetKit
import SwiftUI

@main
struct CleanerWidgetBundle: WidgetBundle {
    var body: some Widget {
        BatteryWidget()
        StorageWidget()
    }
}
