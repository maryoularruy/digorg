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

    private lazy var events: [Event] = [] {
        didSet {
            unresolvedEventsCount.bind(text: "\(events.count) event\(events.count == 1 ? "" : "s")")
            unresolvedEventsTableView.reloadData()
        }
    }
    
    private lazy var eventsForDeletion = [Event]() {
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
        CalendarService.shared.fetchEvents { events in
            events.forEach { event in
                self.events.append(Event(title: event.title, year: self.calendarComponent(event.startDate, .year), isSelected: false, id: event.eventIdentifier, calendar: event.calendar.title, formattedDate: self.formattedDate(event.startDate)))
            }
            self.showPlaceholder()
            // self.tableView.reloadData()
        }
    }
    
    @IBAction func deleteEvents(_ sender: Any) {
        let selectedEvents = events.filter { $0.isSelected }

        deleteEventsFromCalendar(selectedEvents)

        events = events.filter { !$0.isSelected }
     //   tableView.reloadData()
        
        showPlaceholder()
    }
    
    func showPlaceholder() {
        if events.isEmpty {
//            placeholderView.isHidden = false
//            selectAllLabel.isHidden = true
//            selectAllStackView.isHidden = true
//            deleteButton.isHidden = true
//            selectedCounterLabel.isHidden = true
        }
    }
    
    private func deleteEventsFromCalendar(_ events: [Event]) {
         let eventStore = EKEventStore()

         for event in events {
             if let calendarEvent = eventStore.event(withIdentifier: event.id) {
                 do {
                     print("removed:", event.id)
                     try eventStore.remove(calendarEvent, span: .thisEvent)
                 } catch {
                     print("Error removing event from calendar: \(error.localizedDescription)")
                     // Handle error if needed
                 }
             }
         }
     }
    
    func calendarComponent(_ date: Date, _ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: date)
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func selectSection(section: Int) {
        let selectedEventsInSection = events.filter { $0.year == sortedUniqueYears()[section] }
        let allSelectedInSection = selectedEventsInSection.allSatisfy { $0.isSelected }

        for index in selectedEventsInSection.indices {
            let eventIndex = events.firstIndex(of: selectedEventsInSection[index])!
            events[eventIndex].isSelected = !allSelectedInSection
        }
    }
    
    private func sortedUniqueYears() -> [Int] {
        let uniqueYears = Array(Set(events.map { $0.year })).sorted(by: <)
        return uniqueYears
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
        sortedUniqueYears().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let year = sortedUniqueYears()[section]
        return events.filter { $0.year == year }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        
        let year = sortedUniqueYears()[indexPath.section]
        let eventsForYear = events.filter { $0.year == year }
        let event = eventsForYear[indexPath.row]
        
        cell.bind(event: event, (indexPath.section, indexPath.row))
        
        cell.content.backgroundColor = eventsForDeletion.contains(events[indexPath.row]) ? .lightBlueBackground : .white
        
//        cell.titleLabel?.text = event.title
//        cell.calendarLabel.text = event.calendar
//        cell.dateLabel.text = event.formattedDate
//        
//        let checkmarkImage = event.isSelected ? Asset.selectedCheckBox.image : Asset.emptyCheckBox.image
//        cell.checkMarkImageView?.image = checkmarkImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.firstLabel.bind(text: "\(sortedUniqueYears()[section])")
        let year = sortedUniqueYears()[section]
        let eventsForYear = events.filter { $0.year == year }.count
        header.secondLabel.bind(text: "\(eventsForYear) event\(eventsForYear == 1 ? "" : "s")")
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
