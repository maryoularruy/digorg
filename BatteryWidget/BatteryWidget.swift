//
//  BatteryWidget.swift
//  BatteryWidget
//
//  Created by Elena Sedunova on 15.03.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), batteryPercent: 25, isLowPowerModeOn: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(getCurrentBatteryStateEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let entry = getCurrentBatteryStateEntry()
        let nextUpdationDate = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date)!
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .after(nextUpdationDate)))
    }

    private func getCurrentBatteryStateEntry() -> SimpleEntry {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        return SimpleEntry(date: .now,
                               batteryPercent: UIDevice.current.batteryLevel.toPercent(),
                               isLowPowerModeOn: ProcessInfo.processInfo.isLowPowerModeEnabled)
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let batteryPercent: Int
    let isLowPowerModeOn: Bool
    var backgroundColor: Color = .blue
}

struct BatteryWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Battery")
                        .font(.regular13)
                        .foregroundStyle(.lightGrey)
                    
                    Text("\(entry.batteryPercent) %")
                        .font(.semibold24)
                        .foregroundStyle(.paleGrey)
                }
                Spacer()
                Image(.batteryWidgetIcon)
                    .frame(width: 40, height: 40, alignment: .trailing)
            }
            
            Spacer()
            
            Text("No activity")
                .font(.regular13)
                .foregroundStyle(.lightGrey)
            
            Text("Low power mode\n\(entry.isLowPowerModeOn ? "enabled" : "disabled")")
                .font(.medium13)
                .lineLimit(2)
                .foregroundStyle(.paleGrey)
            
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
    }
}

#Preview(as: .systemSmall) {
    BatteryWidget()
} timeline: {
    SimpleEntry(date: .now, batteryPercent: 25, isLowPowerModeOn: true, backgroundColor: .blue)
}
