//
//  FoodTableUseCase.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/07.
//

import Foundation

class SelectFoodsTableUseCase {
    
    let repository = FoodTabelRepositoryImpr()
    
    var selectedFoods: [SelectFoodObject] = []
    
    var selectedFoodsCount:Int {
        selectedFoods.count
    }
    
    var totalEnergy: Int {
        selectedFoods.reduce(0) { totalEnergy, selectfood in
            let energy = Double(selectfood.food.energy) * (selectfood.weight / 100)
            return totalEnergy + Int(energy)
        }
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
    
    init() {
        //TODO:インスタンス生成時にうまくハマるかどうか
        loadSelectFoods()
    }
    
    func add(selectFood: SelectFoodObject) {
        selectedFoods.append(selectFood)
    }
    
    func delete(selectFood: SelectFoodObject) {
        for food in selectedFoods {
            if food.id == selectFood.id {
                repository.delete(selectFoodObject: selectFood)
                loadSelectFoods()
            }
        }
    }
    
    func loadSelectFoods() {
        selectedFoods = repository.loadSelectFoods()
    }
    
    //Adapter?
    func save(selectFood: SelectFoodObject) {
        repository.save(selectFood: selectFood)
    }
    
    func getCompositionValueString(of compositionType: FoodCompositionType) -> String {
        
        let valueString:String
        switch compositionType {
        case .energy: valueString = String(self.totalEnergy) + " kcal"
        case .water: valueString = String(self.totalWater) + " g"
        case .protein: valueString = String(self.totalProtein) + " g"
        case .fat: valueString = String(self.totalFat) + " g"
        case .dietaryfiber: valueString = String(self.totalDietaryFiber) + " g"
        case .carbohydrate: valueString = String(self.totalCarbohydrate) + " g"
        case .weight: valueString = String(self.totalWeight) + "g"
        case .foodCode: return ""
        case .foodName: return ""
        case .category(_): return""
        }

        return valueString
    }
}
