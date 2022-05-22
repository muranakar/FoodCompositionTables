//
//  CompositionType.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/05/01.
//

import Foundation

enum FoodCompositionType: Equatable {
 
    case foodCode
    case foodName
    case water(min:Double?,max:Double?)
    case energy(min:Int?,max:Int?)
    case protein(min:Double?,max:Double?)
    case fat(min:Double?,max:Double?)
    case dietaryfiber(min:Double?,max:Double?)
    case carbohydrate(min:Double?,max:Double?)
    case category(FoodCategoryType)
    case weight(min:Double?,max:Double?)
    
    //名称
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
    
    // MARK: caseが追加された場合には追記必要
    //連想型によりCaseIterableを準拠できないため自作のプロパティ
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
    
    //検索のためのプロパティ
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
    
    //View側の事情？
    func getCompositionValueString(in selectFood:FoodObject) -> String {
        let valueString:String
        
        switch self {
        case .foodCode: valueString = String(selectFood.foodCode )
        case .foodName: valueString = selectFood.foodName
        case .energy: valueString = String(selectFood.energy) + " g"
        case .water: valueString = String(selectFood.water) + " g"
        case .protein: valueString = String(selectFood.protein) + " g"
        case .fat: valueString = String(selectFood.fat) + " g"
        case .dietaryfiber: valueString = String(selectFood.dietaryfiber) + " g"
        case .carbohydrate: valueString = String(selectFood.carbohydrate) + " g"
        case .category: valueString = selectFood.category
        case .weight: valueString = "100gあたり"
        }

        return valueString
    }
}
