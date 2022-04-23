//
//  ResultViewController.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/23.
//

import UIKit

class ResultViewController: UIViewController {

    //ここをView用に作る
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func dimissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target:self,
                                                action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}
