//
//  LandingViewPresenter.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/17/21.
//

import Foundation

protocol LandingViewPresenterProtocol {
    
    var dateChosen: Date { get }
    var trainingPlanViewModels: [TrainingPlanViewModel] { get }
    
    func getSelectedPlan() -> TrainingPlan?
    func select(index: Int)
    
}

struct TrainingPlanViewModel {
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
}

class LandingViewPresenter: LandingViewPresenterProtocol {
    
    private var trainingList: [TrainingPlan] = []
    private weak var view: LandingViewProtocol?
    private var selectedPlanIndex: Int = 0
    
    var dateChosen: Date
    var trainingPlanViewModels: [TrainingPlanViewModel]
    
    init(view: LandingViewProtocol?) {
        self.view = view
        self.dateChosen = Date()
        guard let data = TrainingPlanModel.data, let trainingList = try? JSONDecoder().decode([TrainingPlan].self, from: data) else {
            self.trainingPlanViewModels = []
            return
        }
        self.trainingList = trainingList
        self.trainingPlanViewModels = trainingList.enumerated().map { TrainingPlanViewModel(title: $0.element.title) }
    }
    
    func select(index: Int) {
        guard let _ = self.trainingPlanViewModels[safeIndex: index] else { return }
        self.selectedPlanIndex = index
    }
    
    func getSelectedPlan() -> TrainingPlan? {
        guard let selectedPlan = self.trainingList[safeIndex: self.selectedPlanIndex] else { return nil }
        return selectedPlan
    }
    
}
