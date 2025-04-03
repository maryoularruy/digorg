//
//  StorageWidget.swift
//  CleanerWidget
//
//  Created by Elena Sedunova on 03.04.2025.
//

import WidgetKit
import SwiftUI

struct StorageProvider: TimelineProvider {
    func placeholder(in context: Context) -> StorageWidgetEntry {
        StorageWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (StorageWidgetEntry) -> ()) {
        completion(StorageWidgetEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StorageWidgetEntry] = []
        
        let entry = StorageWidgetEntry(date: Date())
        let nextUpdationDate = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date)!
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .after(nextUpdationDate)))
    }
}


struct StorageWidgetEntry: TimelineEntry {
    let date: Date
    var backgroundColor: Color = .blue
    var isWhiteBackground: Bool = false
}

struct StorageWidgetEntryView : View {
    
    var entry: StorageProvider.Entry
    
    var body: some View {
        HStack {
            
        }
    }
}

struct StorageWidget: Widget {
    let kind: String = "StorageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StorageProvider()) { entry in
            if #available(iOS 17.0, *) {
                StorageWidgetEntryView(entry: entry)
                    .containerBackground(entry.backgroundColor, for: .widget)
            } else {
                StorageWidgetEntryView(entry: entry)
                    .padding()
                    .background(entry.backgroundColor)
            }
        }
        .configurationDisplayName("Storage Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//#Preview(as: .systemMedium) {
//    StorageWidget()
//} timeline: {
//    StorageWidgetEntry(date: .now, backgroundColor: .blue)
//}
