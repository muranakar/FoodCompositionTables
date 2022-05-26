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
        case .foodCode, .foodName, .weight: return self
        case .energy(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min, let max = max else { return false }
                let FoodObjectPropatyValueInt =
                composition.valueAssociatedWithFoodObject(foodObject: $0).int!

                return FoodObjectPropatyValueInt >= min && FoodObjectPropatyValueInt <= max
            }
        case .water(min: let min, max: let max),
             .protein(let min, let max),
             .fat(min: let min, max: let max),
             .dietaryfiber(min: let min, max: let max),
             .carbohydrate(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min, let max = max else { return false }
                let FoodObjectPropatyValueDouble =
                composition.valueAssociatedWithFoodObject(foodObject: $0).double!

                return FoodObjectPropatyValueDouble >= min && FoodObjectPropatyValueDouble <= max
            }
        case .category(let category):
            filetedFoods = self.filter {
                let categoryName = category.name
                return $0.category == categoryName
            }
        }
        return filetedFoods
    }
    func sorted(by composition: FoodCompositionType) -> [FoodObject] {
        // 昇順
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

private extension FoodCompositionType {
    func valueAssociatedWithFoodObject(
        foodObject: FoodObject
    ) -> (
        double: Double?,
        int: Int?,
        string: String?
    ) {
        switch self {
        case .foodCode, .foodName, .weight:
            return (nil, nil, nil)
        case .water:
            return (foodObject.water, nil, nil)
        case .energy:
            return (nil, foodObject.energy, nil)
        case .protein:
            return (foodObject.protein, nil, nil)
        case .fat:
            return (foodObject.fat, nil, nil)
        case .dietaryfiber:
            return (foodObject.dietaryfiber, nil, nil)
        case .carbohydrate:
            return (foodObject.carbohydrate, nil, nil)
        case .category:
            return (nil, nil, foodObject.category)
        }
    }

    func valueAssociatedWithFoodObjectVersion2(
        foodObject: FoodObject
    ) -> Any? {
        switch self {
        case .foodCode, .foodName, .weight:
            return nil
        case .water:
            return foodObject.water
        case .energy:
            return foodObject.energy
        case .protein:
            return foodObject.protein
        case .fat:
            return foodObject.fat
        case .dietaryfiber:
            return foodObject.dietaryfiber
        case .carbohydrate:
            return foodObject.carbohydrate
        case .category:
            return foodObject.category
        }
    }
}
