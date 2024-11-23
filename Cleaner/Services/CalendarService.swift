//
//  CalendarService.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit
import OSLog

final class CalendarService {
    static let shared = CalendarService()
    
    private let eventStore = EKEventStore()
    private lazy var twoYears = TimeInterval(63113852)

    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        } else {
            eventStore.requestAccess(to: .event) { (granted, error) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }

    func fetchEvents(completion: @escaping ([EKEventGroup]) -> Void) {
        let events = eventStore.events(matching: eventStore
            .predicateForEvents(withStart: Date(timeIntervalSinceNow: -twoYears),
                                end: Date(timeIntervalSinceNow: twoYears),
                                calendars: eventStore.calendars(for: .event).filter { $0.allowsContentModifications } ))
        
        completion(sortByYears(events))
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
    
    private func sortByYears(_ events: [EKEvent]) -> [EKEventGroup] {
        let years = Set(events.map { $0.startDate.year() }).sorted(by: <)
        
        var groups = [EKEventGroup]()
        years.forEach { year in
            let events = events.filter { $0.startDate.year() == year }
            groups.append(EKEventGroup(year: year, events: events))
        }
        return groups
    }
}
