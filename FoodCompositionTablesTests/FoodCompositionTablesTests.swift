////
////  FoodCompositionTablesTests.swift
////  FoodCompositionTablesTests
////
////  Created by 山田　天星 on 2022/04/18.
////
//
//import XCTest
//@testable import FoodCompositionTables
//
//class FoodCompositionTablesTests: XCTestCase {
//
//    let foodTableUseCase = FoodTableUseCase()
//
//
//    let food =  FoodCompositionDomain(food: FoodCompositionRealm(id: 2,
//                                                                 protein: 1,
//                                                                 category: ""))
//
//    //nonEffected
//    let testFoods = [
//        FoodCompositionDomain(food: FoodCompositionRealm(id: 1,
//                                                         protein: 20,
//                                                         category: "１ 穀類")),
//        FoodCompositionDomain(food: FoodCompositionRealm(id: 2,
//                                                         protein: 40,
//                                                         category: "２ いも及びでん粉類")),
//        FoodCompositionDomain(food: FoodCompositionRealm(id: 3,
//                                                         protein: 100,
//                                                         category: "２ いも及びでん粉類"))
//    ]
//
////    func test_エラーメッセージを表示させること() {
////        let Nil:Int? = nil
////        XCTAssertNotNil(Nil,"エラーメッセージが表示される")
////    }
//
//    func test_配列に含まれた食品総数の算出(){
//
//        foodTableUseCase.selectedFoods = testFoods
//
//        let totalFoodsCount = foodTableUseCase.totalSelectedFoodCount
//        XCTAssertEqual(totalFoodsCount, testFoods.count)
//    }
//
//    func test_ケトン指標の算出() {
//        //状態
//        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
//        let pfs = PFS(protein: 1, fat: 4, sugar: 1)
//        XCTContext.runActivity(named: "ケトン指標の算出") { _ in
//            XCTContext.runActivity(named: "ケトン比の算出") { _ in
//                //操作
//                let ketogenicRatio = pfc.ketogenicRatio
//                //検証
//                let expected = 2.0
//                XCTAssertEqual(ketogenicRatio, expected)
//            }
//
//            XCTContext.runActivity(named: "ケトン指数の算出") { _ in
//                //操作
//                let ketogenicIndex = pfc.ketogenicIndex
//                //検証
//                let expected = 2.1
//
//                XCTAssertEqual(ketogenicIndex, expected)
//            }
//
//            XCTContext.runActivity(named: "ケトン値") { _ in
//                //操作
//                let ketogenicValue = pfs.ketogenicValue
//                //検証
//                let expected = 2.1
//
//                XCTAssertEqual(ketogenicValue, expected)
//            }
//        }
//    }
//
//    //    func test_ケトン比の算出() {
//    //        //状態
//    //        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
//    //        //操作?
//    //        let ketogenicRatio = pfc.ketogenicRatio
//    //        //検証
//    //        let expected = 2.0
//    //
//    //        XCTAssertEqual(ketogenicRatio, expected)
//    //    }
//    //
//    //    func test_ケトン指数の算出() {
//    //        //状態
//    //        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
//    //        //操作？
//    //        let ketogenicIndex = pfc.ketogenicIndex
//    //        //検証
//    //        let expected = 2.1
//    //
//    //        XCTAssertEqual(ketogenicIndex, expected)
//    //    }
//    //
//    //    func test_ケトン値の算出() {
//    //        //状態
//    //        let pfs = PFS(protein: 1, fat: 7.1, sugar: 1)
//    //        //操作？
//    //        let ketogenicValue = pfs.ketogenicValue
//    //        //検証
//    //        let expected = 3.0
//    //
//    //        XCTAssertEqual(ketogenicValue, expected)
//    //    }
//    //
//    func test_目標ケトン比の必要な脂質量の算出() {
//        //状態
//        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
//        //操作？
//        let lipidRequirement = pfc.lipidRequirementInKetogenicRatio(for: 3.0)
//        //検証
//        let expected = 2.0
//
//        XCTAssertEqual(lipidRequirement, expected)
//    }
//
//    func test_目標ケトン指数の必要な脂質量の算出() {
//        //状態
//        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
//        //操作？
//        let lipidRequirement = pfc.lipidRequirementInKetogenicIndex(for: 3.0)
//        //検証
//        let expected = 3.1
//
//        XCTAssertEqual(lipidRequirement, expected)
//    }
//
//    func test_目標ケトン値の必要な脂質量の算出() {
//        //状態
//        let pfs = PFS(protein: 1, fat: 4, sugar: 1)
//        //操作？
//        let lipidRequirement = pfs.lipidRequirementInKetogenicValue(for: 3.0)
//        //検証
//        let expected = 3.1
//
//        XCTAssertEqual(lipidRequirement, expected)
//    }
//
//    func test_栄養素量_nilでのフィルタリング_空の配列が返されること() {
//        //状態
//
//        //操作
//        let filterdFoods = testFoods.filterFoods(by: .protein(min: nil, max: nil))
//        //検証
//        let expected:[FoodCompositionDomain] = []
//        XCTAssertEqual(filterdFoods, expected)
//    }
//
//    func test_栄養素量でのフィルタリング_栄養素の値含むの範囲内で返されること() {
//        //状態
//
//        //操作
//        let filterdFoods = testFoods.filterFoods(by: .protein(min: 20, max: 50))
//        //検証
//        let expected:[FoodCompositionDomain] = [
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 1,
//                                                             protein: 20,
//                                                             category: "１ 穀類")),
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 2,
//                                                             protein: 40,
//                                                             category: "２ いも及びでん粉類")),
//        ]
//
//        XCTAssertEqual(filterdFoods, expected)
//    }
//
//    func test_栄養素カテゴリ名でのフィルタリング_カテゴリ名が一致する要素のみ返されること() {
//        //状態
//
//        //操作
//        let filterdFoods = testFoods.filterFoods(by: .category(.kokurui))
//        //検証
//        let expected:[FoodCompositionDomain] = [
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 1,
//                                                             protein: 20,
//                                                             category: "１ 穀類"))
//        ]
//
//        XCTAssertEqual(filterdFoods, expected)
//    }
//
//    func test_カテゴリ名によるソート_返される配列に変化がないこと() {
//        //状態
//
//        //操作
//        let sortedSelectFoods = testFoods.sortedFoods(by: .category(.imo))
//        //検証
//        let expected = testFoods
//
//        XCTAssertEqual(sortedSelectFoods, expected)
//    }
//
//    func test_引数nilでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
//        //状態
//
//        //操作
//        let sortedSelectFoods = testFoods.sortedFoods(by: .protein(min: nil, max: nil))
//        //検証
//        let expected = [
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 3,
//                                                             protein: 100,
//                                                             category: "２ いも及びでん粉類")),
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 2,
//                                                             protein: 40,
//                                                             category: "２ いも及びでん粉類")),
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 1,
//                                                             protein: 20,
//                                                             category: "１ 穀類"))
//        ]
//
//        XCTAssertEqual(sortedSelectFoods, expected)
//    }
//
//    func test_引数ありでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
//        //状態
//
//        //操作
//        let sortedSelectFoods = testFoods.sortedFoods(by: .protein(min: 20, max: 50))
//        //検証
//        let expected = [
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 3,
//                                                             protein: 100,
//                                                             category: "２ いも及びでん粉類")),
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 2,
//                                                             protein: 40,
//                                                             category: "２ いも及びでん粉類")),
//            FoodCompositionDomain(food: FoodCompositionRealm(id: 1,
//                                                             protein: 20,
//                                                             category: "１ 穀類"))
//        ]
//
//        XCTAssertEqual(sortedSelectFoods, expected)
//    }
//
//    func test_選択された食品一覧へのの追加_追加する配列の元の要素数に１が加算された値が返されること() {
//        //状態
//
//        //操作
//        let addedSelectFoodList = foodTableUseCase.add(food: food, to: testFoods)
//        //検証
//        XCTAssertEqual(addedSelectFoodList.count, testFoods.count + 1)
//    }
//
//    func test_選択された食品一覧からの削除_削除する配列の元の要素数に１を減じた値が返されること() {
//        //状態
//
//        //操作
//        let deletedSelectFoodList = foodTableUseCase.delete(food: food, from: testFoods)
//        //検証
//        XCTAssertEqual(deletedSelectFoodList.count, testFoods.count - 1)
//    }
//}
//
