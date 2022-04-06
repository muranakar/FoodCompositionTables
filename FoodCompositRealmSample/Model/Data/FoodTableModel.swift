//
//  RealmModel.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/02/23.
//

import Foundation
import RealmSwift

class FoodComposition: Object {
    
    @Persisted var id: Int?
    @Persisted var food_code: Int?
    @Persisted var food_name: String?
    @Persisted var energy: Int?
    @Persisted var water: Double?
    @Persisted var protein: Double?
    @Persisted var fat: Double?
    @Persisted var dietaryfiber: Double?
    @Persisted var carbohydrate: Double?
    @Persisted var category: String?
    
    static let defaultCategory = ["１ 穀類",
                                   "２ いも及びでん粉類",
                                   "３ 砂糖及び甘味類",
                                   "４ 豆類",
                                   "5 種実類",
                                   "6 野菜類",
                                   "7 果実類",
                                   "8 きのこ類",
                                   "9 藻類",
                                   "10 魚介類",
                                   "11 肉類",
                                   "12 卵類",
                                   "13 乳類",
                                   "14 油脂類",
                                   "15 菓子類",
                                   "16 し好飲料類",
                                   "17 調味料及び香辛料類",
                                   "18　調理済み流通食品類"]
}

class SelectFood: Object {
    // 管理用 ID。プライマリーキー
    @Persisted var objectId = ObjectId.generate()
    // 内容
    @Persisted var foodObject: FoodComposition?
    // 日時
    @Persisted var foodWeight: Double = 100.0
    
    override class func primaryKey() -> String? {
        "objectId"
    }
}
