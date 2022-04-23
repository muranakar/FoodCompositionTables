//
//  Nutrients.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/09.
//

import Foundation

enum Composition {

    case foodCode
    case foodName
    case water(min:Double?,max:Double?)
    case energy(min:Int?,max:Int?)
    case protein(min:Double?,max:Double?)
    case fat(min:Double?,max:Double?)
    case dietaryfiber(min:Double?,max:Double?)
    case carbohydrate(min:Double?,max:Double?)
    case category(CategoryType)
    case weight(min:Double?,max:Double?)
    
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
    
    //CaseIterableを準拠できないのでプロパティとして書き起こす
    static var allCases: [Composition] {
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
    
    func valueString(in selectFood:FoodObject) -> String {
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

enum CategoryType:Int, CaseIterable {
    
    case koku = 0
    case imo
    case satou
    case mame
    case syuzitsu
    case yasai
    case kazitsu
    case kinoko
    case sou
    case gyokai
    case niku
    case tamago
    case nyuu
    case yushi
    case kashi
    case sikouinryou
    case tyoumiryou
    case tyourizumi
    
    var name: String {
        switch self {
        case .koku: return "１ 穀類"
        case .imo: return "２ いも及びでん粉類"
        case .satou: return "３ 砂糖及び甘味類"
        case .mame: return "４ 豆類"
        case .syuzitsu: return "5 種実類"
        case .yasai: return "6 野菜類"
        case .kazitsu: return "7 果実類"
        case .kinoko: return "8 きのこ類"
        case .sou: return "9 藻類"
        case .gyokai: return "10 魚介類"
        case .niku: return "11 肉類"
        case .tamago: return "12 卵類"
        case .nyuu: return "13 乳類"
        case .yushi: return "14 油脂類"
        case .kashi: return "15 菓子類"
        case .sikouinryou: return "16 し好飲料類"
        case .tyoumiryou: return "17 調味料及び香辛料類"
        case .tyourizumi: return "18　調理済み流通食品類"
        }
    }
}

enum KetogenicIndexType: Int, CaseIterable {
    
    case ketogenicRatio
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

struct FoodObject: Equatable {
    
    var id: Int?
    var foodCode: Int
    var foodName: String
    var energy: Int
    var water: Double
    var protein: Double
    var fat: Double
    var dietaryfiber: Double
    var carbohydrate: Double
    var category: String
    
    var sugar: Double
    
    var defaultWeight: Double = 100
    
    init(food: FoodComposition) {
        id = food.id
        foodCode = food.food_code ?? 0
        foodName = food.food_name ?? ""
        energy = food.energy ?? 0
        water = food.water ?? 0
        protein = food.protein ?? 0
        fat = food.fat ?? 0
        dietaryfiber = food.dietaryfiber ?? 0
        carbohydrate = food.carbohydrate ?? 0
        category = food.category ?? ""
//        sugar = food.sugar ?? 0
        
        //TODO: sugarの扱いの検討
        sugar = carbohydrate - dietaryfiber
    }
}

struct PFS { // Protein Fat Sugar
    var protein: Double
    var fat: Double
    var sugar: Double
    
    //Enerygy関係はほとんど同様のプロパティがPFSとPFCと二箇所にあって良くない
    var energy: Double { // Atwater
        (protein * 4)
        + (fat * 9)
        + (sugar * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var sugarPercentEnergy: Double {
        (( sugar * 4) / energy ) * 100
    }
    
    var ketogenicValue: Double? {
        if (sugar + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (sugar + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodObject){
        protein = food.protein
        fat = food.fat
        sugar = food.sugar
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, sugar: Double) {
        self.protein = protein
        self.fat = fat
        self.sugar = sugar
    }
    
    // 目標ケトン値に対する必要脂質量の過不足
    func lipidRequirementInKetogenicValue(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( sugar + 0.58 * protein )) / (0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
}

struct PFC { // Protein Fat Carbohydrate
    
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var energy: Double { // Atwaterの係数
        (protein * 4)
        + (fat * 9)
        + (carbohydrate * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var carbohydratePercentEnergy: Double {
        (( carbohydrate * 4) / energy ) * 100
    }
    
    var ketogenicRatio: Double? {  // ケトン比の算出
        if (protein + carbohydrate) == 0 { return nil }
        let index = fat / (protein + carbohydrate)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    var ketogenicIndex: Double? { // ケトン指数の算出
        if (carbohydrate + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (carbohydrate + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodObject){
        protein = food.protein
        fat = food.fat
        carbohydrate = food.carbohydrate
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, carbohydrate: Double) {
        self.protein = protein
        self.fat = fat
        self.carbohydrate = carbohydrate
    }
    
    // 目標ケトン比に対する必要脂質量の過不足
    func lipidRequirementInKetogenicRatio(for targetValue: Double) -> Double? {
        guard let ketogenicRatio = ketogenicRatio else { return nil}
        let lipidRequirement = (targetValue - ketogenicRatio) * (protein + carbohydrate)
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
    
    // 目標ケトン指数に対する必要脂質量の過不足
    func lipidRequirementInKetogenicIndex(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( carbohydrate + 0.58 * protein)) / ( 0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
        
    }
}


