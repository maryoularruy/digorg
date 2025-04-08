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
        StorageWidgetEntry(date: .now, totalSize: 128, busySize: 100, busySizeInPercent: 78)
    }

    func getSnapshot(in context: Context, completion: @escaping (StorageWidgetEntry) -> ()) {
        completion(getCurrentStorageStateEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StorageWidgetEntry] = []
        
        let entry = getCurrentStorageStateEntry()
        let nextUpdationDate = Calendar.current.date(byAdding: .minute, value: 10, to: entry.date)!
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .after(nextUpdationDate)))
    }
    
    private func getCurrentStorageStateEntry() -> StorageWidgetEntry {
        let totalSize = FileManager.default.getTotalStorageSizeInGigabytes() ?? 0
        let freeSize = FileManager.default.getFreeStorageSizeInGigabytes() ?? 0
        let busySize = totalSize - freeSize
        let busySizeInPercent = (busySize * 100) / totalSize
        
        let color: Color
        let isWhiteBackground: Bool
        
        if let colorHex = UserDefaultsService.shared.storageWidgetHexBackground,
           let uiColor = UIColor(hex: colorHex) {
            color = Color(uiColor)
            isWhiteBackground = colorHex == "F9FAFC"
        } else {
            color = Color(.blue)
            isWhiteBackground = false
        }
        
        return StorageWidgetEntry(date: .now,
                                  totalSize: totalSize,
                                  busySize: busySize,
                                  busySizeInPercent: busySizeInPercent,
                                  backgroundColor: color,
                                  isWhiteBackground: isWhiteBackground)
    }
}


struct StorageWidgetEntry: TimelineEntry {
    let date: Date
    let totalSize: Int
    let busySize: Int
    let busySizeInPercent: Int
    var backgroundColor: Color = .blue
    var isWhiteBackground: Bool = false
}

struct StorageWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: StorageProvider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall: smallView()
        case .systemMedium: mediumView()
        default: smallView()
        }
    }
    
    func smallView() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Storage")
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("\(entry.busySizeInPercent) %")
                        .font(.semibold24)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                }
                Spacer()
                Image(entry.isWhiteBackground ? .storageWidgetSmallBlueIcon : .storageWidgetSmallWhiteIcon)
                    .frame(width: 40, height: 40, alignment: .trailing)
            }
            
            Spacer()
            
            Text("Storage Used")
                .font(.regular13)
                .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
            
            Text("\(entry.busySize)GB / \(entry.totalSize)GB")
                .font(.medium13)
                .lineLimit(2)
                .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
        }
    }
    
    func mediumView() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Storage")
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("\(entry.busySizeInPercent) %")
                        .font(.semibold24)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                    
                    Text("Storage Used")
                        .padding(.top, 8)
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("\(entry.busySize)GB / \(entry.totalSize)GB")
                        .font(.medium13)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                }
                
                Spacer()
                
                Image(entry.isWhiteBackground ? .storageWidgetMediumBlueIcon : .storageWidgetMediumWhiteIcon)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(EdgeInsets(top: UIScreen.main.bounds.width > 420 ? 77 : 70, leading: 0, bottom: 0, trailing: 9))
            }
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

#Preview(as: .systemMedium) {
    StorageWidget()
} timeline: {
    StorageWidgetEntry(date: .now, totalSize: 128, busySize: 100, busySizeInPercent: 78)
}
