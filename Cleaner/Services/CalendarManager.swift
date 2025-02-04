//
//  CalendarManager.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit

final class CalendarManager {
    static let shared = CalendarManager()
    
    var selectedEventsForSmartCleaning: [EKEvent] = []
    
    private let eventStore = EKEventStore()
    private lazy var twoYears = TimeInterval(63113852)
    
    func checkStatus(handler: @escaping (EKAuthorizationStatus) -> ()) {
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .notDetermined {
            requestAutorization() { granted in
                handler(granted ? .authorized : .denied)
            }
        } else {
            handler(status)
        }
    }

    func fetchEvents(completion: @escaping ([EKEvent]) -> Void) {
        completion(eventStore.events(matching: eventStore
            .predicateForEvents(withStart: Date(timeIntervalSinceNow: -twoYears),
                                end: Date(timeIntervalSinceNow: twoYears),
                                calendars: eventStore.calendars(for: .event).filter { $0.allowsContentModifications } )))
    }
    
    func deleteEvents(_ events: [EKEvent], completion: @escaping (Bool) -> ()) {
        events.forEach { event in
            if let event = eventStore.event(withIdentifier: event.eventIdentifier) {
                do {
                    try eventStore.remove(event, span: .thisEvent)
                    completion(true)
                } catch {
                    print("\(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func sortByYears(_ events: [EKEvent]) -> [EKEventGroup] {
        let years = Set(events.map { $0.startDate.year() }).sorted(by: <)
        
        var groups = [EKEventGroup]()
        years.forEach { year in
            let events = events.filter { $0.startDate.year() == year }
            groups.append(EKEventGroup(year: year, events: events))
        }
        return groups
    }
    
    private func requestAutorization(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, _ in
                completion(granted)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, _ in
                completion(granted)
            }
        }
    }
}
