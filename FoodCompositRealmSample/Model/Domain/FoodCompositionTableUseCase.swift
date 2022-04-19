//
//  FoodTableUseCase.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/07.
//

import Foundation

class FoodCompositionTableUseCase {
    
    let selectedFoods: [SelectFood] = []
    
    var selectedFoodsCount:Int {
        selectedFoods.count
    }
    
    var totalProtein: Double {
        selectedFoods.reduce(0) { totalProtein, selectfood in
            let protein = selectfood.food.protein * ( selectfood.weight / 100 )
            return totalProtein + protein
        }
    }
    
    var totalFat: Double {
        selectedFoods.reduce(0) { totalFat, selectfood in
            let fat = selectfood.food.fat * ( selectfood.weight / 100 )
            return totalFat + fat
        }
    }
    
    var totalCarbohydrate: Double {
        selectedFoods.reduce(0) { totalCarbohydrate, selectfood in
            let carbohydrate = selectfood.food.carbohydrate * ( selectfood.weight / 100 )
            return totalCarbohydrate + carbohydrate
        }
    }
    
    var totalDietaryFiber: Double {
        selectedFoods.reduce(0) { totalDietaryFiber, selectfood in
            let dietaryFiber = selectfood.food.dietaryfiber * ( selectfood.weight / 100 )
            return totalDietaryFiber + dietaryFiber
        }
    }
    
    var totalWater: Double {
        selectedFoods.reduce(0) { totalWater, selectfood in
            let water = selectfood.food.water * ( selectfood.weight / 100 )
            return totalWater + water
        }
    }
    
    var totalWeight: Double {
        selectedFoods.reduce(0) { totalWeight, selectFood in
            let weight = selectFood.weight
            return totalWeight + weight
        }
    }
    
    func add(selectFood: SelectFood, to foodList:[SelectFood])  -> [SelectFood] {
        var foodList = foodList
        foodList.append(selectFood)
        return foodList
    }
    
    func delete(selectFood: SelectFood, from foodList: [SelectFood]) -> [SelectFood]{
        var foodList = foodList
        for i in 0...(foodList.count - 1) {
            if foodList[i].food.id == selectFood.food.id {
                foodList.remove(at: i)
                print(foodList)
                return foodList
            }
        }
        return foodList
    }
}

private extension Array where Element == FoodCompositionObject {
    
    func filterFoods(by composition: Composition) -> [FoodCompositionObject] {
        
        var filetedFoods: [FoodCompositionObject] = []
        
        switch composition {
        case .foodCode: return self
        case .foodName: return self
        case .energy(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.energy >= min && $0.energy <= max
            }
        case .water(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.water >= min && $0.water <= max
            }
        case .protein(let min, let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.protein >= min && $0.protein <= max
            }
        case .fat(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.fat >= min && $0.fat <= max
            }
        case .dietaryfiber(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.dietaryfiber >= min && $0.dietaryfiber <= max
            }
        case .carbohydrate(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.carbohydrate >= min && $0.carbohydrate <= max
            }
//        case .weight(let min, let max):
//            filetedFoods = self.filter {
//                guard let min = min, let max = max else { return false }
//                return $0.weight >= min && $0.weight <= max
//            }
        case .category(let category):
            filetedFoods = self.filter {
                let categoryName = category.name
                return $0.category == categoryName
            }
        case .weight: return self
        }
        
        return filetedFoods
    }
    
    func sortedFoods(by composition: Composition) -> [FoodCompositionObject] {
        //昇順
        switch composition {
        case .energy: return self.sorted { $0.energy > $1.energy }
        case .water: return self.sorted { $0.water > $1.water }
        case .protein: return self.sorted { $0.protein > $1.protein }
        case .fat: return self.sorted { $0.fat > $1.fat }
        case .dietaryfiber: return self.sorted { $0.dietaryfiber > $1.dietaryfiber }
        case .carbohydrate: return self.sorted { $0.carbohydrate > $1.carbohydrate }
//        case .weight:  return self.sorted { $0.weight > $1.weight }
        case .category: return self
        case .foodCode: return self
        case .foodName: return self
        case .weight: return self
        }
    }
}
