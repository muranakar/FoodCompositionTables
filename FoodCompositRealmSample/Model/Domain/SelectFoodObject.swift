//
//  SelectFoodObject.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/20.
//

import Foundation

struct SelectFoodObject {
    var id = UUID().uuidString
    var food: FoodObject
    var weight: Double
    
    init?(food: FoodObject, weight: Double) {
        guard weight >= 0 else { return nil }
        self.food = food
        self.weight = weight
    }
}
