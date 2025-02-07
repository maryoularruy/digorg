//
//  CalendarViewController.swift
//  Cleaner
//
//  Created by Alex on 21.12.2023.
//

import EventKit
import UIKit
import BottomPopup

enum CalendarEntryFrom {
    case smartClean, mainScreen
}

final class CalendarViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var unresolvedEventsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedEventsTableView: UITableView!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    lazy var from: CalendarEntryFrom = .mainScreen
    
    private lazy var calendarManager = CalendarManager.shared
    
    private lazy var eventGroups: [EKEventGroup] = [] {
        didSet {
            unresolvedEventsCount.bind(text: "\(eventsCount) event\(eventsCount == 1 ? "" : "s")")
            selectionButton.isClickable = !eventGroups.isEmpty
            unresolvedEventsTableView.reloadData()
            if eventGroups.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: eventsForDeletion.count == eventsCount ? .deselectAll : .selectAll)
                
                switch from {
                case .smartClean:
                    toolbar.toolbarButton.bind(text: "Apply")
                    toolbar.toolbarButton.isClickable = true
                case .mainScreen:
                    toolbar.toolbarButton.bind(text: eventsForDeletion.isEmpty ? "Delete 0 Items" : "Delete Items (\(eventsForDeletion.count))")
                    toolbar.toolbarButton.isClickable = !eventsForDeletion.isEmpty
                }
                
                emptyStateView = nil
            }
        }
    }
    
    private var eventsCount: Int {
        eventGroups.reduce(0) { $0 + $1.events.count }
    }
    
    private lazy var eventsForDeletion = Set<EKEvent>() {
        didSet {
            selectionButton.bind(text: eventsForDeletion.count == eventsCount ? .deselectAll : .selectAll)
            
            switch from {
            case .smartClean:
                toolbar.toolbarButton.bind(text: "Apply")
                toolbar.toolbarButton.isClickable = true
            case .mainScreen:
                toolbar.toolbarButton.bind(text: eventsForDeletion.isEmpty ? "Delete 0 Items" : "Delete Items (\(eventsForDeletion.count))")
                toolbar.toolbarButton.isClickable = !eventsForDeletion.isEmpty
            }
            
            unresolvedEventsTableView.reloadData()
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
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
        unresolvedEventsTableView.register(cellType: ItemCell.self)
    }
    
    private func reloadData() {
        calendarManager.fetchEvents { [weak self] events in
            guard let self else { return }
            eventGroups = calendarManager.sortByYears(events)
        }
        
        if from == .smartClean {
            eventsForDeletion.insert(calendarManager.selectedEventsForSmartCleaning)
        }
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        
        switch from {
        case .smartClean:
            toolbar.toolbarButton.bind(text: "Apply")
        case .mainScreen:
            toolbar.toolbarButton.bind(text: "Back")
        }
        
        toolbar.toolbarButton.isClickable = true
        emptyStateView = view.createEmptyState(type: .noEvents)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func isContainsForDeletion(events: [EKEvent]) -> Bool {
        var isContains = true
        for i in 0..<events.count {
            if !eventsForDeletion.contains(events[0]) {
                isContains = false
                break
            }
        }
        return isContains
    }
}

extension CalendarViewController: ViewControllerProtocol {
    func setupUI() {
        selectionButton.delegate = self
        toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
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
        let cell = tableView.dequeueReusableCell(for: indexPath) as ItemCell
        cell.delegate = self
        
        cell.setupSingleCellInSection()
        cell.bind(event: eventGroups[indexPath.section].events[indexPath.row], (indexPath.section, indexPath.row))
        
        cell.checkBoxButton.image = eventsForDeletion.contains(eventGroups[indexPath.section].events[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.content.backgroundColor = eventsForDeletion.contains(eventGroups[indexPath.section].events[indexPath.row]) ? .lightBlue : .paleGrey
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ItemCellHeader()
        header.delegate = self
        header.bind(section: section)
        
        header.firstLabel.bind(text: "\(eventGroups[section].year)")
        header.secondLabel.isHidden = false
        header.secondLabel.bind(text: "\(eventGroups[section].events.count) event\(eventGroups[section].events.count == 1 ? "" : "s")")
        
        header.selectAllButton.bind(text: isContainsForDeletion(events: eventGroups[section].events) ? .deselectAll : .selectAll)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
}

extension CalendarViewController: ItemCellProtocol, HeaderSelectAllButtonDelegate {
    func tapOnCheckBox(_ position: (Int, Int)) {
        tapOnCell(position)
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        let event = eventGroups[position.0].events[position.1]
        if eventsForDeletion.contains(event) {
            eventsForDeletion.remove(event)
        } else {
            eventsForDeletion.insert(event)
        }
    }
    
    func tapOnSelectAllButton(_ section: Int) {
        let events = eventGroups[section].events
        if isContainsForDeletion(events: events) {
            events.forEach { eventsForDeletion.remove($0) }
        } else {
            eventsForDeletion.insert(events)
        }
    }
}

extension CalendarViewController: SelectionButtonDelegate {
    func tapOnButton() {
        if eventsCount == eventsForDeletion.count {
            eventsForDeletion.removeAll()
        } else {
            eventsForDeletion.removeAll()
            eventGroups.forEach { eventGroup in
                eventsForDeletion.insert(eventGroup.events)
            }
        }
        unresolvedEventsTableView.reloadData()
    }
}

extension CalendarViewController: ActionToolbarDelegate, BottomPopupDelegate {
    func tapOnActionButton() {
        switch from {
        case .smartClean:
            calendarManager.selectedEventsForSmartCleaning = Array(eventsForDeletion)
            navigationController?.popViewController(animated: true)
            
        case .mainScreen:
            if eventsForDeletion.isEmpty {
                navigationController?.popViewController(animated: true)
            } else {
                guard let vc = UIStoryboard(name: ConfirmActionViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionViewController.idenfifier) as? ConfirmActionViewController else { return }
                vc.popupDelegate = self
                vc.height = 238
                vc.actionButtonText = "Delete Items (\(eventsForDeletion.count))"
                vc.type = .deleteContacts
                DispatchQueue.main.async { [weak self] in
                    self?.present(vc, animated: true)
                }
            }
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            calendarManager.deleteEvents(Array(eventsForDeletion)) { [weak self] res in
                guard let self else { return }
                switch res {
                case true:
                    let successView = SuccessView(frame: SuccessView.myFrame)
                    successView.bind(type: .successDelete)
                    successView.center = view.center
                    view.addSubview(successView)
                    successView.setHidden { [weak self] in
                        guard let self else { return }
                        successView.removeFromSuperview()
                        eventsForDeletion.removeAll()
                        reloadData()
                    }

                case false: break
                }
            }
        }
    }
}
