//
//  CalendarService.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit
import Foundation

class CalendarService {
    static let shared = CalendarService()
    private let eventStore = EKEventStore()

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

    func fetchEvents(completion: @escaping ([EKEvent]?) -> Void) {
        let calendars = eventStore.calendars(for: .event)

        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date().addingTimeInterval(2 * 365 * 24 * 60 * 60), calendars: calendars)

        let events = eventStore.events(matching: predicate)

        completion(events)
    }
}
