//
//  FoodCompositionTableUseCase.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/20.
//

import Foundation



class FoodCompositionTableUseCase {
        
    let repository = FoodTabelRepositoryImpr()
        
    var foodTable: [FoodObject] {
        repository.loadFoodTable()
    }
}

// TODO: filterであるので関数型のように使えるといい
// ただcaseで連想型利用している場合がほとんどで、ぱっと見わかりづらい

extension Array where Element == FoodObject {
    
    func filter(by composition: FoodCompositionType) -> [FoodObject] {
        
        var filetedFoods: [FoodObject] = []
        
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
        case .category(let category):
            filetedFoods = self.filter {
                let categoryName = category.name
                return $0.category == categoryName
            }
        case .weight: return self
        }
        
        return filetedFoods
    }
    
    func sorted(by composition: FoodCompositionType) -> [FoodObject] {
        //昇順
        switch composition {
        case .foodCode: return self
        case .foodName: return self
        case .energy: return self.sorted { $0.energy > $1.energy }
        case .water: return self.sorted { $0.water > $1.water }
        case .protein: return self.sorted { $0.protein > $1.protein }
        case .fat: return self.sorted { $0.fat > $1.fat }
        case .dietaryfiber: return self.sorted { $0.dietaryfiber > $1.dietaryfiber }
        case .carbohydrate: return self.sorted { $0.carbohydrate > $1.carbohydrate }
        case .category: return self
        case .weight: return self
        }
    }
}
