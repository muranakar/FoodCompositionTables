//
//  Test.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/18.
//

import Foundation

//
////PFCに関することは集約
////エネルギー計算やケトン比
////どちらかというとUseCaseのような役割かもしれない
////食品から計算に利用するような機能はここに集約させる
//
//struct SelectFoodDomain {
//    let food: FoodCompositionDomain
//    let weight: Double
//}
//
////Tableの単純な合計等
//class FoodTableUseCase {
//
//    var selectedFoods: [FoodCompositionDomain] = []
//
//    //TODO: selectedFoods -> userSelectFoods へ変更
//    var userSelectFoods: [SelectFoodDomain] = []
//
//    //選んだ食品数 ApplicationService
//    var totalSelectedFoodCount: Int {
//        selectedFoods.count
//    }
//
//    //DomainService
//    var totalProtein: Double {
//        selectedFoods.reduce(0) { totalProtein, food in
//            let protein = food.protein
//            return totalProtein + protein
//        }
//    }
//
//    var totalWeight: Double {
//        selectedFoods.reduce(0) { totalWeight, food in
//            let weight = food.weight
//            return totalWeight + weight
//        }
//    }
//
//    func add(food: FoodCompositionDomain, to foodList:[FoodCompositionDomain])  -> [FoodCompositionDomain] {
//        var foodList = foodList
//        foodList.append(food)
//        return foodList
//    }
//
//    func delete(food: FoodCompositionDomain, from foodList: [FoodCompositionDomain]) -> [FoodCompositionDomain]{
//        var foodList = foodList
//        for i in 0...(foodList.count - 1) {
//            if foodList[i].id == food.id {
//                foodList.remove(at: i)
//                print(foodList)
//                return foodList
//            }
//        }
//        return foodList
//    }
//}
//
//extension Array where Element == FoodCompositionDomain {
//
//    func filterFoods(by composition: Composition) -> [FoodCompositionDomain] {
//
//        var filetedFoods: [FoodCompositionDomain] = []
//        switch composition {
//        case .protein(let min, let max):
//            filetedFoods = self.filter {
//                guard let min = min , let max = max else { return false }
//                return $0.protein >= min && $0.protein <= max
//            }
//        case .weight(let min, let max):
//            filetedFoods = self.filter {
//                guard let min = min, let max = max else { return false }
//                return $0.weight >= min && $0.weight <= max
//            }
//        case .category(let category):
//            filetedFoods = self.filter {
//                let categoryName = category.name
//                return $0.category == categoryName
//            }
//        }
//
//        return filetedFoods
//    }
//
//
//    func sortedFoods(by composition: Composition) -> [FoodCompositionDomain] {
//        //昇順
//        switch composition {
//        case .protein: return self.sorted { $0.protein > $1.protein }
//        case .weight:  return self.sorted { $0.weight > $1.weight }
//        case .category: return self
//        }
//    }
//}
