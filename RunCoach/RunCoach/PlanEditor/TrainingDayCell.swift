//
//  TrainingDayCell.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/20/21.
//

import Foundation
import UIKit

final class TrainingDayCell: UICollectionViewCell {
    
    struct Constant {
        static let horizontalPadding: CGFloat = 0
        static let verticalPadding: CGFloat = 0
    }

    var unitPicker = UILabel()
    var textField = UITextField()
    var dateLabel = UILabel()
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = Constant.horizontalPadding
        mainStackView.distribution = .fillEqually
        return mainStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.contentView.backgroundColor = .white
        
        self.dateLabel.textAlignment = .center
        
        self.unitPicker.textAlignment = .center
        self.unitPicker.translatesAutoresizingMaskIntoConstraints = false

        self.textField.textAlignment = .center
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.unitPicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.addArrangedSubview(self.textField)
        self.mainStackView.addArrangedSubview(self.unitPicker)
        self.mainStackView.addArrangedSubview(self.dateLabel)
        self.mainStackView.constrainToView(self.contentView, top: Constant.verticalPadding, left: Constant.horizontalPadding, bottom: -Constant.verticalPadding, right: -Constant.horizontalPadding)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.textField.text = nil
    }
    
}
