//
//  FoodCompositionViewController.swift
//  FoodCompositionTables
//  Created by 山田　天星 on 2022/04/09.
//

import UIKit

protocol FoodRegistrationDelegate: AnyObject {
    func transitPresentingVC()
}

final class FoodCompositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FoodRegistrationDelegate?

    //prepareで分ける
    var selectFood: FoodObject?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerFoodButton: UIButton!
    @IBOutlet private weak var foodWeightTextField: UITextField!
    @IBOutlet private weak var foodWeightRegisterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CompositionCell")
        tableView.delegate = self
        tableView.dataSource = self
        setup()
        
        registerFoodButton
            .addTarget(self,
                       action: #selector(registerFoodTouchUpInside),
                       for: .touchUpInside)
    }
    
    private func setup() {
        foodWeightRegisterView.layer.cornerRadius = 20
        foodWeightRegisterView.layer.borderColor = UIColor.white.cgColor
        foodWeightRegisterView.layer.borderWidth = 0.5
        foodWeightRegisterView.layer.shadowOffset = CGSize(width: 0, height: 2)
        foodWeightRegisterView.layer.shadowColor = UIColor.black.cgColor
        foodWeightRegisterView.layer.shadowOpacity = 0.5
    }
    
    @objc private func registerFoodTouchUpInside() {
        guard let selectFood = selectFood else { return }
        guard let selectFoodWeight
                = Double(foodWeightTextField.text ?? "") else { return }
       
        guard let selectFoodObject = SelectFoodObject(food: selectFood,
                                                      weight: selectFoodWeight) else { return }
        
        SelectFoodsTableUseCase().save(selectFood: selectFoodObject)
        delegate?.transitPresentingVC()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FoodCompositionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell") else { fatalError() }
        guard let selectFood = selectFood else { return cell }
        //栄養素名称
        let composition = FoodCompositionType.allCases[indexPath.row]
        let compositionName = composition.nameString
        //栄養素量
        let compositionValueString = composition.valueString(in: selectFood)

        var content = UIListContentConfiguration.valueCell()
        content.text = compositionName
        content.secondaryText = compositionValueString
        cell.contentConfiguration = content
        return cell
    }
}


