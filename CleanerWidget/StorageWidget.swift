//
//  StorageWidget.swift
//  CleanerWidget
//
//  Created by Elena Sedunova on 03.04.2025.
//

import WidgetKit
import SwiftUI

// Локальные функции для виджета
extension FileManager {
    func getWidgetTotalStorageSizeInGigabytes() -> Int? {
        do {
            let attributes = try attributesOfFileSystem(forPath: NSHomeDirectory())
            if let totalSize = attributes[.systemSize] as? NSNumber {
                return Int(totalSize.int64Value / (1024 * 1024 * 1024))
            }
        } catch {
            print("Error getting total storage size: \(error)")
        }
        return nil
    }
    
    func getWidgetFreeStorageSizeInGigabytes() -> Int? {
        do {
            let attributes = try attributesOfFileSystem(forPath: NSHomeDirectory())
            if let freeSize = attributes[.systemFreeSize] as? NSNumber {
                return Int(freeSize.int64Value / (1024 * 1024 * 1024))
            }
        } catch {
            print("Error getting free storage size: \(error)")
        }
        return nil
    }
}

extension UIColor {
    convenience init?(widgetHex: String) {
        let r, g, b, a: CGFloat

        if widgetHex.hasPrefix("#") {
            let start = widgetHex.index(widgetHex.startIndex, offsetBy: 1)
            let hexColor = String(widgetHex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

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
        let totalSize = FileManager.default.getWidgetTotalStorageSizeInGigabytes() ?? 0
        let freeSize = FileManager.default.getWidgetFreeStorageSizeInGigabytes() ?? 0
        let busySize = totalSize - freeSize
        let busySizeInPercent = (busySize * 100) / totalSize
        
        let color: Color
        let isWhiteBackground: Bool
        
        if let colorHex = UserDefaults(suiteName: "group.com.cleaner.app")?.string(forKey: "storageWidgetHexBackgroundColor"),
           let uiColor = UIColor(widgetHex: colorHex) {
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
