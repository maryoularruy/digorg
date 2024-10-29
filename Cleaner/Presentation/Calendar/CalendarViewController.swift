//
//  CalendarViewController.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit
import UIKit

final class CalendarViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedEventsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedEventsTableView: UITableView!

    private lazy var eventGroups: [EKEventGroup] = [] {
        didSet {
            let eventsCount = eventGroups.reduce(0) { $0 + $1.events.count }
            unresolvedEventsCount.bind(text: "\(eventsCount) event\(eventsCount == 1 ? "" : "s")")
            unresolvedEventsTableView.reloadData()
        }
    }
    
    private lazy var eventsForDeletion = Set<EKEvent>() {
        didSet {
            unresolvedEventsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
        setupUnresolvedEventsTableView()
    }
    
    private func setupUnresolvedEventsTableView() {
        unresolvedEventsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        CalendarService.shared.requestAccess { [weak self] granted in
            if granted { self?.fetchEvents() }
            else { }
        }
    }
    
    private func fetchEvents() {
        CalendarService.shared.fetchEvents { [weak self] events in
            self?.eventGroups = events
        }
    }
    
//    private func deleteEventsFromCalendar(_ events: [Event]) {
//         let eventStore = EKEventStore()
//
//         for event in events {
//             if let calendarEvent = eventStore.event(withIdentifier: event.id) {
//                 do {
//                     print("removed:", event.id)
//                     try eventStore.remove(calendarEvent, span: .thisEvent)
//                 } catch {
//                     print("Error removing event from calendar: \(error.localizedDescription)")
//                     // Handle error if needed
//                 }
//             }
//         }
//     }
    
    func calendarComponent(_ date: Date, _ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: date)
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

extension CalendarViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        eventGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventGroups[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        
        cell.bind(event: eventGroups[indexPath.section].events[indexPath.row], (indexPath.section, indexPath.row))
        
        cell.content.backgroundColor = eventsForDeletion.contains(eventGroups[indexPath.section].events[indexPath.row]) ? .lightBlueBackground : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.firstLabel.bind(text: "\(eventGroups[section].year)")
        header.secondLabel.bind(text: "\(eventGroups[section].events.count) event\(eventGroups[section].events.count == 1 ? "" : "s")")
        header.secondLabel.isHidden = false
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }    
}

extension CalendarViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
         
    }
    
    func tapOnCell(_ position: (Int, Int)) {
         
    }
}
