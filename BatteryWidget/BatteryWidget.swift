//
//  BatteryWidget.swift
//  BatteryWidget
//
//  Created by Elena Sedunova on 15.03.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BatteryWidgetEntry {
        BatteryWidgetEntry(date: Date(), batteryPercent: 25, isLowPowerModeOn: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (BatteryWidgetEntry) -> ()) {
        completion(getCurrentBatteryStateEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [BatteryWidgetEntry] = []
        
        let entry = getCurrentBatteryStateEntry()
        let nextUpdationDate = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date)!
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .after(nextUpdationDate)))
    }

    private func getCurrentBatteryStateEntry() -> BatteryWidgetEntry {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let color: Color
        let isWhiteBackground: Bool
        
        if let colorHex = UserDefaultsService.shared.batteryWidgetHexBackground,
           let uiColor = UIColor(hex: colorHex) {
            color = Color(uiColor)
            isWhiteBackground = colorHex == "F9FAFC"
        } else {
            color = Color(.blue)
            isWhiteBackground = false
        }
        
        return BatteryWidgetEntry(date: .now,
                                  batteryPercent: UIDevice.current.batteryLevel.toPercent(),
                                  isLowPowerModeOn: ProcessInfo.processInfo.isLowPowerModeEnabled,
                                  backgroundColor: color,
                                  isWhiteBackground: isWhiteBackground)
    }
}

struct BatteryWidgetEntry: TimelineEntry {
    let date: Date
    let batteryPercent: Int
    let isLowPowerModeOn: Bool
    var backgroundColor: Color = .blue
    var isWhiteBackground: Bool = false
}

struct BatteryWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

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
                    Text("Battery")
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("\(entry.batteryPercent) %")
                        .font(.semibold24)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                }
                Spacer()
                Image(entry.isWhiteBackground ? .batteryWidgetSmallBlueIcon : .batteryWidgetSmallWhiteIcon)
                    .frame(width: 40, height: 40, alignment: .trailing)
            }
            
            Spacer()
            
            Text("No activity")
                .font(.regular13)
                .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
            
            Text("Low power mode\n\(entry.isLowPowerModeOn ? "enabled" : "disabled")")
                .font(.medium13)
                .lineLimit(2)
                .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
        }
    }
    
    func mediumView() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Battery")
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("\(entry.batteryPercent) %")
                        .font(.semibold24)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                    
                    Text("No activity")
                        .padding(.top, 8)
                        .font(.regular13)
                        .foregroundStyle(entry.isWhiteBackground ? .darkGrey : .lightGrey)
                    
                    Text("Low power mode \(entry.isLowPowerModeOn ? "enabled" : "disabled")")
                        .font(.medium13)
                        .foregroundStyle(entry.isWhiteBackground ? Color(.black) : .paleGrey)
                }
                
                Spacer()
                
                Image(entry.isWhiteBackground ? .batteryWidgetMediumBlueIcon : .batteryWidgetMediumWhiteIcon)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 9))
            }
        }
    }
}

struct BatteryWidget: Widget {
    let kind: String = "BatteryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BatteryWidgetEntryView(entry: entry)
                    .containerBackground(entry.backgroundColor, for: .widget)
            } else {
                BatteryWidgetEntryView(entry: entry)
                    .padding()
                    .background(entry.backgroundColor)
            }
        }
        .configurationDisplayName("Battery Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    BatteryWidget()
} timeline: {
    BatteryWidgetEntry(date: .now, batteryPercent: 25, isLowPowerModeOn: true, backgroundColor: .blue)
}
