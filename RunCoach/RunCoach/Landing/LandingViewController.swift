//
//  LandingViewController.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/16/21.
//

import UIKit

protocol LandingViewProtocol where Self: UIViewController {
    
    var presenter: LandingViewPresenterProtocol { get }
    
}

class LandingViewController: UIViewController {

    @IBOutlet weak var raceDatePicker: UIDatePicker!
    
    @IBOutlet weak var planPicker: UIPickerView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    private lazy var internalPresenter: LandingViewPresenter = {
        return LandingViewPresenter(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.planPicker.dataSource = self
        self.planPicker.delegate = self
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        let flowLayout = UICollectionViewFlowLayout()
        let size: CGSize = {
            let noOfCellsInRow = TrainingPlanModel.days
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((self.view.bounds.width*2 - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
        }()
        flowLayout.itemSize = size
        flowLayout.scrollDirection = .horizontal
        guard let trainingPlan = self.presenter.getSelectedPlan() else { return }
        let planEditorViewController: PlanEditorViewController = PlanEditorViewController(trainingPlan: PersonalizedTrainingPlan(trainingPlan: trainingPlan, raceDate: raceDatePicker.date),collectionViewLayout: flowLayout)
        self.navigationController?.pushViewController(planEditorViewController, animated: false)
    }

}

extension LandingViewController: LandingViewProtocol {
    
    var presenter: LandingViewPresenterProtocol {
        return self.internalPresenter
    }
    
}

extension LandingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.presenter.trainingPlanViewModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.presenter.trainingPlanViewModels[safeIndex: row]?.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.presenter.select(index: row)
    }
    
}
