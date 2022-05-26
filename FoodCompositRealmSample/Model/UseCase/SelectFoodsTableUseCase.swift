//
//  FoodTableUseCase.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/07.
//

import Foundation

enum KetogenicIndexType: Int, CaseIterable {
    case ketogenicRatio = 0
    case ketogenicIndex
    case ketogenicValue
    
    var name: String {
        switch self {
        case .ketogenicRatio: return "ケトン比"
        case .ketogenicIndex: return "ケトン指数"
        case .ketogenicValue: return "ケトン値"
        }
    }
}

class SelectFoodsTableUseCase {
    let repository = FoodTabelRepositoryImpr()
    var selectedFoods: [SelectFoodObject] = []
    var selectedFoodsCount: Int {
        selectedFoods.count
    }
    // TODO: 計算量がコンピューテッドプロパティには適していない？関数にするべき？
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
        loadSelectFoods()
    }
    func calculateKetogenicTypeValue(in ketogenicType: KetogenicIndexType) -> Double? {
        let protein = totalProtein
        let fat = totalFat
        let carbohydrate = totalCarbohydrate
        switch ketogenicType {
        case .ketogenicRatio:
            let pfc = PFC(protein: protein, fat: fat, carbohydrate: carbohydrate)
            return pfc.ketogenicRatio
        case .ketogenicIndex:
            let pfc = PFC(protein: protein, fat: fat, carbohydrate: carbohydrate)
            return pfc.ketogenicIndex
        case .ketogenicValue:
            let sugar = totalCarbohydrate - totalDietaryFiber
            let pfs = PFS(protein: protein, fat: fat, sugar: sugar)
            return pfs.ketogenicValue
        }
    }
    func add(selectFood: SelectFoodObject) {
        selectedFoods.append(selectFood)
    }
    func delete(selectFood: SelectFoodObject) {
        repository.delete(selectFoodObject: selectFood)
        loadSelectFoods()
    }
    func loadSelectFoods() {
        selectedFoods = repository.loadSelectFoods()
    }
    // Adapter?
    func save(selectFood: SelectFoodObject) {
        repository.save(selectFood: selectFood)
    }
    func getCompositionValueString(of compositionType: FoodCompositionType) -> String {
        let valueString: String
        switch compositionType {
        case .energy: valueString = String(self.totalEnergy) + " kcal"
        case .water: valueString = String(self.totalWater) + " g"
        case .protein: valueString = String(self.totalProtein) + " g"
        case .fat: valueString = String(self.totalFat) + " g"
        case .dietaryfiber: valueString = String(self.totalDietaryFiber) + " g"
        case .carbohydrate: valueString = String(self.totalCarbohydrate) + " g"
        case .weight: valueString = String(self.totalWeight) + "g"
        case .foodCode, .foodName, .category: return ""
        }

        return valueString
    }
}
