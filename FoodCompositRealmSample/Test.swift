//
//  Test.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/18.
//

import Foundation

//enum Composition {
//
//    case protein(min:Double?,max:Double?)
//    case weight(min:Double?,max:Double?)
//    case category(CategoryType)
//
//    var nameString: String {
//        switch self {
//        case .protein: return "たんぱく質"
//        case .weight: return "重量"
//        case .category: return "カテゴリ"
//        }
//    }
//
//    //CaseIterableを準拠できないのでプロパティとして書き起こす
//    static var allCases: [Composition] {
//        return [
//            .protein(min: nil, max: nil),
//            .weight(min: nil, max: nil),
//            .category(.kokurui)
//        ]
//    }
//}
//
//enum CategoryType:Int, CaseIterable {
//    case kokurui = 0
//    case imo
//    case satou
//
//    var name: String {
//        switch self {
//        case .kokurui: return "１ 穀類"
//        case .imo: return "２ いも及びでん粉類"
//        case .satou: return "３ 砂糖及び甘味類"
//            //        case .kokurui: return Self.defaultCategory[CategoryType.kokurui.rawValue]
//            //        case .imo: return Self.defaultCategory[CategoryType.imo.rawValue]
//            //        case .satou: return Self.defaultCategory[CategoryType.satou.rawValue]
//        }
//    }
//
//    func CompositionString(at composition: Composition) -> String {
//        composition.nameString
//    }
//}
//
//enum KetogenicIndexType: Int, CaseIterable {
//    case ketogenicRatio
//    case ketogenicIndex
//    case ketogenicValue
//
//    var name: String {
//        switch self {
//        case .ketogenicRatio: return "ケトン比"
//        case .ketogenicIndex: return "ケトン指数"
//        case .ketogenicValue: return "ケトン値"
//        }
//    }
//}
//
////データベースから返ってくる値
//struct FoodCompositionRealm {
//    var id: Int?
//    var protein: Double?
//    var fat: Double?
//    var carbohydrate: Double?
//    var sugar: Double?
//    var category: String?
//}
//
////}
////ベースはTable
////利用するためのModel
////Ketoneのためじゃなくて合計ではない計算をさせることにおいてはここを通す
//struct PFC { // Protein Fat Carbohydrate
//
//    var protein: Double
//    var fat: Double
//    var carbohydrate: Double
//    var energy: Double { // Atwaterの係数
//        (protein * 4)
//        + (fat * 9)
//        + (carbohydrate * 4)
//    }
//
//    var proteinPercentEnergy: Double {
//        (( protein * 4) / energy ) * 100
//    }
//
//    var fatPercentEnergy: Double {
//        (( fat * 9) / energy ) * 100
//    }
//
//    var carbohydratePercentEnergy: Double {
//        (( carbohydrate * 4) / energy ) * 100
//    }
//
//    var ketogenicRatio: Double? {  // ケトン比の算出
//        if (protein + carbohydrate) == 0 { return nil }
//        let index = fat / (protein + carbohydrate)
//        let roundedIndex = round(index * 10) / 10
//        return roundedIndex
//    }
//
//    var ketogenicIndex: Double? { // ケトン指数の算出
//        if (carbohydrate + 0.1 * fat + 0.58 * protein) == 0 { return nil }
//        let index =  (0.9 * fat + 0.46 * protein) / (carbohydrate + 0.1 * fat + 0.58 * protein)
//        let roundedIndex = round(index * 10) / 10
//        return roundedIndex
//    }
//
//    //Tableからのイニシャライズ
//    init(food: FoodCompositionDomain){
//        protein = food.protein
//        fat = food.fat
//        carbohydrate = food.carbohydrate
//    }
//
//    //UIからのイニシャライズ
//    init(protein: Double, fat: Double, carbohydrate: Double) {
//        self.protein = protein
//        self.fat = fat
//        self.carbohydrate = carbohydrate
//    }
//
//    // 目標ケトン比に対する必要脂質量の過不足
//    func lipidRequirementInKetogenicRatio(for targetValue: Double) -> Double? {
//        guard let ketogenicRatio = ketogenicRatio else { return nil}
//        let lipidRequirement = (targetValue - ketogenicRatio) * (protein + carbohydrate)
//        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
//        return roundedLipidRequirement
//    }
//
//    // 目標ケトン指数に対する必要脂質量の過不足
//    func lipidRequirementInKetogenicIndex(for targetValue: Double) -> Double? {
//        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
//        let lipidRequirement = (0.46 * protein - targetValue * ( carbohydrate + 0.58 * protein)) / ( 0.1 * targetValue - 0.9) - fat
//        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
//        return roundedLipidRequirement
//
//    }
//}
//
////PFCに関することは集約
////エネルギー計算やケトン比
////どちらかというとUseCaseのような役割かもしれない
////食品から計算に利用するような機能はここに集約させる
//struct PFS { // Protein Fat Sugar
//
//    var protein: Double
//    var fat: Double
//    var sugar: Double
//
//    //Enerygy関係はほとんど同様のプロパティがPFSとPFCと二箇所にあって良くない
//    var energy: Double { // Atwater
//        (protein * 4)
//        + (fat * 9)
//        + (sugar * 4)
//    }
//
//    var proteinPercentEnergy: Double {
//        (( protein * 4) / energy ) * 100
//    }
//
//    var fatPercentEnergy: Double {
//        (( fat * 9) / energy ) * 100
//    }
//
//    var sugarPercentEnergy: Double {
//        (( sugar * 4) / energy ) * 100
//    }
//
//    var ketogenicValue: Double? {
//        if (sugar + 0.1 * fat + 0.58 * protein) == 0 { return nil }
//        let index =  (0.9 * fat + 0.46 * protein) / (sugar + 0.1 * fat + 0.58 * protein)
//        let roundedIndex = round(index * 10) / 10
//        return roundedIndex
//    }
//
//    //Tableからのイニシャライズ
//    init(food: FoodCompositionDomain){
//        protein = food.protein
//        fat = food.fat
//        sugar = food.sugar
//    }
//
//    //UIからのイニシャライズ
//    init(protein: Double, fat: Double, sugar: Double) {
//        self.protein = protein
//        self.fat = fat
//        self.sugar = sugar
//    }
//
//    // 目標ケトン値に対する必要脂質量の過不足
//    func lipidRequirementInKetogenicValue(for targetValue: Double) -> Double? {
//        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
//        let lipidRequirement = (0.46 * protein - targetValue * ( sugar + 0.58 * protein )) / (0.1 * targetValue - 0.9) - fat
//        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
//        return roundedLipidRequirement
//    }
//}
//
////Modelとして利用する値
//struct FoodCompositionDomain: Equatable {
//
//    var id: Int?
//    var protein: Double
//    var fat: Double
//    var carbohydrate: Double
//    var sugar: Double
//    var category: String
//    var weight:Double = 100.0
//
//    init(food: FoodCompositionRealm) {
//        //これがOKなのかどうか
//        self.id = food.id ?? UUID().hashValue
//        self.protein = food.protein ?? 0
//        self.fat = food.fat ?? 0
//        self.carbohydrate = food.carbohydrate ?? 0
//        self.sugar = food.sugar ?? 0
//        self.category = food.category ?? ""
//    }
//}
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
