//
//  PlanEditorPresenter.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/21/21.
//

import UIKit

protocol PlanEditorPresenterProtocol {
    
    var viewModels: [PersonalPlanViewModel] { get }
    
    func setPersonalTrainingPlan(trainingPlan: PersonalizedTrainingPlan)
    func getDate(at index: Int) -> Date?
    func updateSaved(at index: Int)
    func hasSuccessfulSaves() -> Bool
    
}

struct PersonalPlanModel {
    
    var date: Date
    var quantity: Int
    var unit: TrainingUnit
    var isSaved: Bool = false
    
}

struct PersonalPlanViewModel {
    
    var dateString: String
    var quantityString: String
    var unitString: String
    
    init(model: PersonalPlanModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        self.dateString = dateFormatter.string(from: model.date)
        self.quantityString = String(model.quantity)
        self.unitString = model.unit.rawValue
    }
    
}

final class PlanEditorPresenter: PlanEditorPresenterProtocol {
 
    private weak var view: PlanEditorViewProtocol?
    
    private var models: [PersonalPlanModel] = []
    var viewModels: [PersonalPlanViewModel] = []
    
    init(view: PlanEditorViewProtocol?) {
        self.view = view
    }
    
    func setPersonalTrainingPlan(trainingPlan: PersonalizedTrainingPlan) {
        let totalDays = trainingPlan.trainingDays.count
        self.models = trainingPlan.trainingDays.enumerated().map {
            let daysToRaceDay = totalDays - $0.offset
            return PersonalPlanModel(date:  Calendar.current.date(byAdding: .day, value: -daysToRaceDay, to: trainingPlan.raceDate) ?? Date() , quantity: $0.element.quantity, unit: $0.element.unit)
        }
        self.viewModels = self.models.map { PersonalPlanViewModel(model: $0) }
    }
    
    func getDate(at index: Int) -> Date? {
        guard let model = self.models[safeIndex: index] else { return nil }
        return model.date
    }
    
    func updateSaved(at index: Int) {
        guard let _ = self.models[safeIndex: index] else { return }
        self.models[index].isSaved = true
    }
    
    func hasSuccessfulSaves() -> Bool {
        // TO DO: redefine to be more strict
        return self.models.contains(where: {$0.isSaved} )
    }
    
}
