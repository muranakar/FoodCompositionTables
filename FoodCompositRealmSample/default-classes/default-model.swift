import Foundation
import RealmSwift

class FoodComposition: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var food_code: Int = 0
    @objc dynamic var food_name: String = ""
    @objc dynamic var energy: Int = 0
    @objc dynamic var water: Double = 0
    @objc dynamic var protein: Double = 0
    @objc dynamic var fat: Double = 0
    @objc dynamic var dietaryfiber: Double = 0
    @objc dynamic var carbohydrate: Double = 0
    @objc dynamic var category: String = ""
}

class SelectFood: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var foodObject: FoodComposition?
    @objc dynamic var foodWeight: Double = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}
