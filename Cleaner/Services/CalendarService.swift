//
//  CalendarService.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit

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

    func fetchEvents(completion: @escaping ([EKEvent]) -> Void) {
        completion(eventStore.events(matching: eventStore
            .predicateForEvents(withStart: Date(timeIntervalSinceNow: -twoYears),
                                end: Date(timeIntervalSinceNow: twoYears),
                                calendars: eventStore.calendars(for: .event).filter { $0.allowsContentModifications } )))
    }
}
