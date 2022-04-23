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
    
//    var count: Int
//    mutating func next() -> Int? {
//        defer { count -= 1 }
//        return count == 0 ? nil : count
//    }
}
