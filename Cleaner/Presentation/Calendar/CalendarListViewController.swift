//
//  CalendarListViewController.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit
import UIKit

class CalendarListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    var events: [Event] = [] {
        didSet {
            updateSelectedCountLabel()
            tableView.reloadData()
        }
    }
    @IBOutlet weak var selectAllStackView: UIStackView!
    @IBOutlet weak var selectedCounterLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var deleteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: ImageTitleSubtitleTableViewCell.self)
        CalendarService.shared.requestAccess { granted in
             if granted {
                 self.fetchEvents()
             } else {
                 
             }
        }
        self.tableView.register(cellType: CalendarTableViewCell.self)
        registerCustomHeaderView()
        
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: +dummyViewHeight, right: 0)
        
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
        selectAllStackView.addTapGestureRecognizer {
            let allSelected = self.events.allSatisfy { $0.isSelected }
            for index in self.events.indices {
                self.events[index].isSelected = !allSelected
            }
        }
        
   //     if events.allSatisfy({ $0.isSelected == false }) {
  //          deleteButton.setBackgroundImage(Asset.notActiveButtonBG.image, for: .normal)
 //       }
    }
    
    private func updateSelectedCountLabel() {
        let selectedCount = events.filter { $0.isSelected }.count
        selectedCounterLabel.text = "Selected: \(selectedCount)"
        if selectedCount == events.count {
            selectAllLabel.text = "Deselect all"
            checkMarkImage.image = Asset.selectedCheckBox.image
        } else {
            selectAllLabel.text = "Select all"
            checkMarkImage.image = Asset.emptyCheckBox.image
        }
    }
    
    func fetchEvents() {
        CalendarService.shared.fetchEvents { events in
            if let events = events {
                for event in events {
                    if event.calendar.allowsContentModifications {
                        self.events.append(Event(title: event.title, year: self.calendarComponent(event.startDate, .year), isSelected: false, id: event.eventIdentifier, calendar: event.calendar.title, formattedDate: self.formattedDate(event.startDate)))
                    }
                }
                self.showPlaceholder()
               // self.tableView.reloadData()
            } else {
                self.showPlaceholder()
                // Handle error
            }
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
            placeholderView.isHidden = false
            selectAllLabel.isHidden = true
            selectAllStackView.isHidden = true
            deleteButton.isHidden = true
            selectedCounterLabel.isHidden = true
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
    
    func registerCustomHeaderView() {
        tableView.register(
            UINib(nibName: "CalendarHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CalendarHeaderView"
        )
        tableView.register(
            UINib(nibName: "CalendarFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CalendarFooterView"
        )
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

extension CalendarListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedUniqueYears().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let year = sortedUniqueYears()[section]
        return events.filter { $0.year == year }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        
        let year = sortedUniqueYears()[indexPath.section]
        let eventsForYear = events.filter { $0.year == year }
        let event = eventsForYear[indexPath.row]
        
        cell.titleLabel?.text = event.title
        cell.calendarLabel.text = event.calendar
        cell.dateLabel.text = event.formattedDate
        
        let checkmarkImage = event.isSelected ? Asset.selectedCheckBox.image : Asset.emptyCheckBox.image
        cell.checkMarkImageView?.image = checkmarkImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CalendarHeaderView") as? CalendarHeaderView
        headerView?.section = section
        let year = sortedUniqueYears()[section]
        let eventsForYear = events.filter { $0.year == year }
        headerView?.events = self.events.filter { $0.year == year }
        let eventCount = eventsForYear.count
        headerView?.yearLabel.text = "\(year): \(eventCount)"
        headerView?.checkboxImageView.addTapGestureRecognizer {
            self.selectSection(section: section)
            headerView?.events = self.events.filter { $0.year == year }
            headerView?.select()
        }
        headerView?.setup()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CalendarFooterView") as? CalendarFooterView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexForEvent(at: indexPath)
        events[selectedIndex].isSelected.toggle()
    }
    
    func indexForEvent(at indexPath: IndexPath) -> Int {
        let rowsInPreviousSections = indexPath.section > 0 ? (0..<indexPath.section).reduce(0) { $0 + tableView.numberOfRows(inSection: $1) } : 0
        let index = rowsInPreviousSections + indexPath.row
        return index
    }
}
