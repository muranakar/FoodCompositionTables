//
//  FoodCompositionTablesTests.swift
//  FoodCompositionTablesTests
//
//  Created by 山田　天星 on 2022/04/18.
//

import XCTest
@testable import FoodCompositionTables

class FoodCompositionTablesTests: XCTestCase {

    let foodTableUseCase = FoodCompositionTableUseCase()
    let selectFoodsTableUseCase = SelectFoodsTableUseCase()

    let testFood1 =  FoodObject(id: 0,
                                foodCode: 0,
                                foodName: "test1",
                                energy: 10,
                                water: 10,
                                protein: 10,
                                fat: 10,
                                dietaryfiber: 10,
                                carbohydrate: 10,
                                category: "１ 穀類",
                                sugar: 10,
                                defaultWeight: 10)
    
    let testFood2 =  FoodObject(id: 1,
                                foodCode: 1,
                                foodName: "test2",
                                energy: 20,
                                water: 20,
                                protein: 20,
                                fat: 20,
                                dietaryfiber: 20,
                                carbohydrate: 20,
                                category: "２ いも及びでん粉類",
                                sugar: 20,
                                defaultWeight: 20)
    
    let testFood3 =  FoodObject(id: 0,
                                foodCode: 0,
                                foodName: "test3",
                                energy: 30,
                                water: 30,
                                protein: 30,
                                fat: 30,
                                dietaryfiber: 30,
                                carbohydrate: 30,
                                category: "３ 砂糖及び甘味類",
                                sugar: 30,
                                defaultWeight: 30)

    func test_ケトン指標の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        let pfs = PFS(protein: 1, fat: 4, sugar: 1)
        
        XCTContext.runActivity(named: "ケトン指標の算出") { _ in
            XCTContext.runActivity(named: "ケトン比の算出") { _ in
                //操作
                let ketogenicRatio = pfc.ketogenicRatio
                //検証
                let expected = 2.0
                XCTAssertEqual(ketogenicRatio, expected)
            }

            XCTContext.runActivity(named: "ケトン指数の算出") { _ in
                //操作
                let ketogenicIndex = pfc.ketogenicIndex
                //検証
                let expected = 2.1

                XCTAssertEqual(ketogenicIndex, expected)
            }

            XCTContext.runActivity(named: "ケトン値") { _ in
                //操作
                let ketogenicValue = pfs.ketogenicValue
                //検証
                let expected = 2.1

                XCTAssertEqual(ketogenicValue, expected)
            }
        }
    }

    func test_目標ケトン比の必要な脂質量の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作？
        let lipidRequirement = pfc.lipidRequirementInKetogenicRatio(for: 3.0)
        //検証
        let expected = 2.0

        XCTAssertEqual(lipidRequirement, expected)
    }

    func test_目標ケトン指数の必要な脂質量の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作？
        let lipidRequirement = pfc.lipidRequirementInKetogenicIndex(for: 3.0)
        //検証
        let expected = 3.1

        XCTAssertEqual(lipidRequirement, expected)
    }

    func test_目標ケトン値の必要な脂質量の算出() {
        //状態
        let pfs = PFS(protein: 1, fat: 4, sugar: 1)
        //操作？
        let lipidRequirement = pfs.lipidRequirementInKetogenicValue(for: 3.0)
        //検証
        let expected = 3.1

        XCTAssertEqual(lipidRequirement, expected)
    }

    func test_栄養素量_nilでのフィルタリング_空の配列が返されること() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let filterdFoods = testFoods.filter(by: .protein(min: nil, max: nil))
        //検証
        let expected: [FoodObject] = []
        XCTAssertEqual(filterdFoods, expected)
    }

    func test_栄養素量でのフィルタリング_栄養素の値含むの範囲内で返されること() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let filterdFoods = testFoods.filter(by: .protein(min: 20, max: 50))
        //検証
        let expected = [testFood2, testFood3]

        XCTAssertEqual(filterdFoods, expected)
    }

    func test_栄養素カテゴリ名でのフィルタリング_カテゴリ名が一致する要素のみ返されること() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let filterdFoods = testFoods.filter(by: .category(.koku))
        //検証
        let expected = [testFood1]

        XCTAssertEqual(filterdFoods, expected)
    }

    func test_カテゴリ名によるソート_返される配列に変化がないこと() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let sortedSelectFoods = testFoods.sorted(by: .category(.imo))
        //検証
        let expected = [testFood1, testFood2, testFood3]

        XCTAssertEqual(sortedSelectFoods, expected)
    }

    func test_引数nilでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let sortedSelectFoods = testFoods.sorted(by: .protein(min: nil, max: nil))
        //検証
        let expected = [testFood3, testFood2, testFood1]

        XCTAssertEqual(sortedSelectFoods, expected)
    }

    func test_引数ありでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
        //状態
        let testFoods = [testFood1, testFood2, testFood3]
        //操作
        let sortedSelectFoods = testFoods.sorted(by: .protein(min: 30, max: 50))
        //検証
        let expected = [testFood3, testFood2, testFood1]

        XCTAssertEqual(sortedSelectFoods, expected)
    }

    func test_選択された食品一覧へのの追加_追加する配列の元の要素数に１が加算された値が返されること() {
//        //状態
//        let testFoods = [testFood1, testFood2, testFood3]
//
//        //操作
//        let testAddFood =  FoodObject(id: 4,
//                                foodCode: 4,
//                                foodName: "testAdd",
//                                energy: 40,
//                                water: 40,
//                                protein: 40,
//                                fat: 40,
//                                dietaryfiber: 40,
//                                carbohydrate: 40,
//                                category: "３ 砂糖及び甘味類",
//                                sugar: 40,
//                                defaultWeight: 40)
//
//        //TODO: Repositoryのモックを作らなければいけない
//        //検証
//        XCTAssertEqual(addedSelectFoodList.count, testFoods.count + 1)
    }

    func test_選択された食品一覧からの削除_削除する配列の元の要素数に１を減じた値が返されること() {
//        //状態
//
//        //操作
//        let deletedSelectFoodList = foodTableUseCase.delete(food: food, from: testFoods)
//        //検証
//        XCTAssertEqual(deletedSelectFoodList.count, testFoods.count - 1)
    }
}

