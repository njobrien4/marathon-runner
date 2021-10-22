//
//  TrainingPlan.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/17/21.
//

import Foundation

class TrainingPlanModel {
    
    static let data = """
    [
        {"title": "Hansons Advanced",
        "days": [
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 10, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"},
            { "quantity": 12, "unit": "miles" },
            { "quantity": 90, "unit": "minutes"}
        ]},
        {"title": "Hansons Beginner",
        "days": [
            { "quantity": 1, "unit": "miles" },
            { "quantity": 30, "unit": "minutes"}
        ]}
    ]
    """.data(using: .utf8)
    
    static let days = 7.0
    
}

struct TrainingPlan: Decodable {
    
    var title: String
    var days: [TrainingDay]
    
    func getWeeks() -> Int {
        return Int((Double(self.days.count)/TrainingPlanModel.days).rounded(.up))
    }
    
}

struct TrainingDay: Decodable {
    
    var quantity: Int
    var unit: TrainingUnit
    
}

enum TrainingUnit: String, Decodable {
    
    case kilometers
    case miles
    case minutes
    case hours
    
}

