//
//  InputFoodViewController.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/02/25.
//

import UIKit

protocol FoodRegistrationDelegate: AnyObject {
    func transitPresentingVC()
    func cancelResistration()
}

final class FoodRegistrationViewController: UIViewController {
    
    @IBOutlet private weak var foodSettingView: UIView!
    @IBOutlet private weak var foodNameLabel: UILabel!
    @IBOutlet private weak var foodWeightTextField: UITextField!
    @IBOutlet private weak var foodRegisterButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    weak var delegate: FoodRegistrationDelegate?
    var selectingFood: FoodComposition?
    var selectedFood: SelectFood = .init()
    let defaultFoodWeight = 100.0
    private var realmRepository = FoodTabelRepositoryImpr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configure()
        
        foodRegisterButton
            .addTarget(self,
                       action: #selector(registerFoodTouchUpInside),
                       for: .touchUpInside)
        
        cancelButton
            .addTarget(self,
                       action: #selector(dismissTouchUpInside),
                       for: .touchUpInside)
    }
    
    private func setup(){
        foodSettingView.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target:self,
                                                action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func configure(){
        foodNameLabel.text = selectingFood?.food_name
        foodWeightTextField.text = String(defaultFoodWeight)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func dismissTouchUpInside(){
        delegate?.cancelResistration()
    }
    
    @objc private func registerFoodTouchUpInside() {
        print("registerFoodTouchUpInside")
        selectedFood.foodObject = selectingFood
        selectedFood.foodWeight = Double(foodWeightTextField!.text ?? "") ?? 0
        realmRepository.save(selectFood: selectedFood)
        
        delegate?.transitPresentingVC()
    }
}
