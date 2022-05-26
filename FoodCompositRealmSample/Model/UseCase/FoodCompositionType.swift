//
//  CompositionType.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/05/01.
//

import Foundation

enum FoodCompositionType: Equatable, CaseIterable {
    case foodCode
    case foodName
    case water(min: Double?, max: Double?)
    case energy(min: Int?, max: Int?)
    case protein(min: Double?, max: Double?)
    case fat(min: Double?, max: Double?)
    case dietaryfiber(min: Double?, max: Double?)
    case carbohydrate(min: Double?, max: Double?)
    case category(FoodCategoryType)
    case weight(min: Double?, max: Double?)
    // 名称
    var nameString: String {
        switch self {
        case .foodCode: return "食品番号"
        case .foodName: return "食品名"
        case .water:  return "水分量"
        case .energy: return "エネルギー量"
        case .protein: return "たんぱく質"
        case .fat: return "脂質量"
        case .dietaryfiber: return "食物繊維"
        case .carbohydrate: return "炭水化物"
        case .category: return "カテゴリ"
        case .weight: return "重量"
        }
    }
    // TODO: caseが追加された場合には追記必要
    // 連想型によりCaseIterableを準拠できないため自作のプロパティ
    static var allCases: [FoodCompositionType] {
        return [
            .foodCode,
            .foodName,
            .water(min: nil, max: nil),
            .energy(min: nil, max: nil),
            .protein(min: nil, max: nil),
            .fat(min: nil, max: nil),
            .dietaryfiber(min: nil, max: nil),
            .carbohydrate(min: nil, max: nil),
            .category(.koku),
            .weight(min: nil, max: nil)
        ]
    }
    
    // 検索のためのプロパティ
    static var searchCases: [FoodCompositionType] {
        return [
            .water(min: nil, max: nil),
            .energy(min: nil, max: nil),
            .protein(min: nil, max: nil),
            .fat(min: nil, max: nil),
            .dietaryfiber(min: nil, max: nil),
            .carbohydrate(min: nil, max: nil),
            .weight(min: nil, max: nil)
        ]
    }
    
    // TODO: View側の事情？
    func getCompositionValueString(in selectFood: FoodObject) -> String {
        let valueString: String
        switch self {
        case .foodCode, .foodName, .category:
            valueString = convettToFoodObjectRelationValue(foodObject: selectFood)
        case .energy, .water, .protein, .fat, .dietaryfiber, .carbohydrate:
            valueString = convettToFoodObjectRelationValue(foodObject: selectFood) + " g"
        case .weight:
            valueString = "100gあたり"
        }
        return valueString
    }

    func convettToFoodObjectRelationValue(foodObject: FoodObject) -> String {
        switch self {
        case .foodCode:
            return "\(String(foodObject.foodCode))"
        case .foodName:
            return "\(String(foodObject.foodName))"
        case .water:
            return "\(String(foodObject.water))"
        case .energy:
            return  "\(String(foodObject.energy))"
        case .protein:
            return "\(String(foodObject.protein))"
        case .fat:
            return "\(String(foodObject.fat))"
        case .dietaryfiber:
            return "\(String(foodObject.dietaryfiber))"
        case .carbohydrate:
            return "\(String(foodObject.carbohydrate))"
        case .category:
            return "\(String(foodObject.category))"
        case .weight:
            return "\(String(foodObject.defaultWeight))"
            // fatalError("\(#function):weightの数値は使用しない。")
        }
    }
}
