//
//  PlanEditorViewController.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/17/21.
//

import Foundation
import UIKit
import EventKit

protocol PlanEditorViewProtocol: UICollectionViewController {
    
    var presenter: PlanEditorPresenterProtocol { get }
    
}

struct PersonalizedTrainingPlan {
    
    var trainingDays: [TrainingDay]
    var raceDate: Date
    
    init(trainingPlan: TrainingPlan, raceDate: Date) {
        self.trainingDays = trainingPlan.days
        self.raceDate = raceDate
    }
    
}


final class PlanEditorViewController: UICollectionViewController, PlanEditorViewProtocol {
    
    struct Constant {
        static let cellIdentifier = "trainingDayCell"
    }
    
    private lazy var internalPresenter: PlanEditorPresenter = {
        return PlanEditorPresenter(view: self)
    }()
    
    lazy var noAccessAlert: UIAlertController = {
        let cantAddToCalendarAlert = UIAlertController(title: "Access Denied", message: "Please provide access to the calendar so you don't miss your runs!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        cantAddToCalendarAlert.addAction(okAction)
        cantAddToCalendarAlert.preferredAction = okAction
        return cantAddToCalendarAlert
    }()
    
    lazy var successAlert: UIAlertController = {
        let cantAddToCalendarAlert = UIAlertController(title: "Success!", message: "Your runs have been added to your calendar! No more excuses!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        cantAddToCalendarAlert.addAction(okAction)
        cantAddToCalendarAlert.preferredAction = okAction
        return cantAddToCalendarAlert
    }()
    
    var presenter: PlanEditorPresenterProtocol {
        return self.internalPresenter
    }
    
    // MARK:- Intializers
    init(trainingPlan: PersonalizedTrainingPlan, collectionViewLayout: UICollectionViewLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
        self.presenter.setPersonalTrainingPlan(trainingPlan: trainingPlan)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Not implemented.")
    }
    
    override func viewDidLoad() {
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextNow))
        self.collectionView.register(TrainingDayCell.self, forCellWithReuseIdentifier: Constant.cellIdentifier)
        self.collectionView.isScrollEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.viewModels.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.cellIdentifier, for: indexPath) as? TrainingDayCell, let viewModel = self.presenter.viewModels[safeIndex: indexPath.row] else {
                  assertionFailure("Can't create CatalogCell for indexPath \(indexPath)")
                  return UICollectionViewCell()
        }
        cell.unitPicker.text = viewModel.unitString
        cell.textField.text = viewModel.quantityString
        cell.dateLabel.text = viewModel.dateString
        return cell
    }
    
    @objc private func didTapNextNow() {
        self.checkAuthorizationForCalendar()
    }
    
    private func checkAuthorizationForCalendar() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.insertEvents(store: eventStore)
            case .denied:
                self.navigationController?.present(noAccessAlert, animated: true, completion: nil)
                print("Access denied")
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion: {[weak self] (granted: Bool, error: Error?) -> Void in
                      if granted {
                        self?.insertEvents(store: eventStore)
                      } else {
                        guard let alert = self?.noAccessAlert else { return }
                        self?.navigationController?.present(alert, animated: true, completion: nil)
                        print("Access denied")
                      }
                })
            default:
                print("Case default")
        }
    }
    private func insertEvents(store: EKEventStore) {
        self.presenter.viewModels.enumerated().forEach( {
            guard let date = self.presenter.getDate(at: $0.offset) else { return }
            self.insertEvent(store: store, startDate: date, eventTitle: "\($0.element.quantityString) \($0.element.unitString)", index: $0.offset)
        })
        guard self.presenter.hasSuccessfulSaves() else { return }
        DispatchQueue.main.async {
            self.navigationController?.present(self.successAlert, animated: true, completion: nil)
        }
    }
    
    private func insertEvent(store: EKEventStore, startDate: Date, eventTitle: String, index: Int) {
        let event:EKEvent = EKEvent(eventStore: store)
        event.title = eventTitle
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(TimeInterval(60*60))
        event.isAllDay = true
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
        } catch let error as NSError {
        print("failed to save event with error : \(error)")
        }
        self.presenter.updateSaved(at: index)
        print("Saved Event")
    }
    
}
