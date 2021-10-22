//
//  UIView+Additions.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/20/21.
//

import UIKit

extension UIView {
    
    func constrainToView(_ view: UIView, top: CGFloat = 0.0, left: CGFloat = 0.0, bottom: CGFloat = 0.0, right: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: right)
            ])
    }
    
}
