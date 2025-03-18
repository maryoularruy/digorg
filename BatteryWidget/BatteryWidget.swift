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
        let entry = SimpleEntry(date: Date(), batteryPercent: 25, isLowPowerModeOn: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        getCurrentBatteryState { entry in
            
//                    for hourOffset in 0 ..< 5 {
//                        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: entry.date)!
//                        let entry = SimpleEntry(date: entryDate, batteryPercent: UIDevice.current.batteryLevel.toPercent(), isLowPowerModeOn: ProcessInfo.processInfo.isLowPowerModeEnabled)
//                        entries.append(entry)
//                    }
//            
//                    let timeline = Timeline(entries: entries, policy: .atEnd)
//                    completion(timeline)
            
            
            entries.append(entry)
            completion(Timeline(entries: entries, policy: .atEnd))
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    
    private func getCurrentBatteryState(completion: @escaping (SimpleEntry) -> Void) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        completion(SimpleEntry(date: .now,
                               batteryPercent: UIDevice.current.batteryLevel.toPercent(),
                               isLowPowerModeOn: ProcessInfo.processInfo.isLowPowerModeEnabled))
        
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
