//
//  FoodCompositionViewController.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/09.
//

import UIKit

class FoodCompositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectFood: FoodCompositionObject?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CompositionCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Composition.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell") else { fatalError() }
//        guard let nutrient = Composition(rawValue: indexPath.row) else { return cell }
        let nutrient = Composition.allCases[indexPath.row]
        let nutrientNameString = nutrient.nameString
        
        guard let selectFood = selectFood else { return cell }

        var valueString: String
        switch nutrient {
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

        var content = UIListContentConfiguration.valueCell()
        content.text = nutrientNameString
        content.secondaryText = valueString
        cell.contentConfiguration = content
        return cell
    }
}
