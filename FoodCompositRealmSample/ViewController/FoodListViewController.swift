//
//  ViewController.swift
//  FoodCompositRealmSample
//
//  Created by toaster on 2022/01/25.
//

import UIKit

protocol FoodListViewTransitonDelegate: AnyObject {
    func transitPresentingVC(_: () -> Void)
}

//ValueObject
// TODO: よくない使い方していないか？
struct Section {
    let number: Int
    //IndexPath型を渡した場合
    init(at indexPath: IndexPath) {
        self.number = indexPath.section
    }
    //sectionを直接渡した場合
    init(_ section: Int) {
        self.number = section
    }
}

// TODO: リストを表示する際に読み込みが遅れるのを直したい
class FoodListViewController: UIViewController,FoodRegistrationDelegate {
    
    weak var delegate: FoodListViewTransitonDelegate?
    
    private var selectingFood: FoodObject?
    private var foodList: [FoodObject] = []
    private var searchedFoodList: [FoodObject] = []
    
    @IBOutlet private weak var foodSearchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchSettingButton: UIButton!
    
    //検索時のTableViewを覆い隠す用
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var contentsCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        //        setupSearchBar()
        configure()
        configureSearchBar()
        
        searchSettingButton
            .addTarget(
                self,
                action: #selector(searchSettingButtonTapped),
                for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let foodCompositonVC = segue.destination as? FoodCompositionViewController else { return }
        guard let selectingFood = selectingFood else { return }
        foodCompositonVC.selectFood = selectingFood
        foodCompositonVC.delegate = self
    }
    
    private func configure() {
        foodList = FoodCompositionTableUseCase().foodTable
    }
    
    private func configureSearchBar() {
        foodSearchBar.delegate = self
        foodSearchBar.showsCancelButton = false
        foodSearchBar.showsSearchResultsButton = true
    }
    
    private func setSearchRules() {
        searchSettingButton.layer.borderWidth = 1
        searchSettingButton.layer.borderColor = UIColor.white.cgColor
        searchSettingButton.layer.shadowColor = UIColor.black.cgColor
        searchSettingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @objc func searchSettingButtonTapped() {
        guard let searchSettingVC =
                storyboard?
                .instantiateViewController(
                    withIdentifier:
                        "SearchSettingViewController") else { return }
        
        if #available(iOS 15.0, *) {
            if let sheet = searchSettingVC.sheetPresentationController {
                sheet.detents = [
                    .medium(),
                    .large()
                ]
            }
            present(searchSettingVC, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func transitPresentingVC() {
        delegate?.transitPresentingVC {
            print(String(describing: delegate?.transitPresentingVC))
        }
        self.dismiss(animated: true)
    }
    
    func arrangeCell(of foods: [FoodObject], in categorySection: Section) -> [FoodObject] {
        
        let sectionCategory = FoodCategoryType.allCases[categorySection.number]
        
        for case sectionCategory in FoodCategoryType.allCases {
            let filterdFoods = foods.filter {
                $0.category == sectionCategory.name
            }
            return filterdFoods
        }
        //filterにかからなければ空の配列
        return []
    }
    
    func searchedResultFoods(between section: Section) -> [FoodObject] {
        
        let resultedFoods: [FoodObject]
        if foodSearchBar.searchTextField.text!.isEmpty {
            resultedFoods = arrangeCell(of: foodList, in: section)
        } else {
            resultedFoods = arrangeCell(of: searchedFoodList, in: section)
        }
        
        return resultedFoods
    }
}

extension FoodListViewController: UITableViewDelegate, UITableViewDataSource {
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchedFoods = searchedResultFoods(between: Section(at: indexPath))
        self.selectingFood = searchedFoods[indexPath.row]
        performSegue(withIdentifier: "toFoodCompositionVC", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FoodCategoryType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //CategoryTypeによるsectionの区別
        return FoodCategoryType.allCases[section].name
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchedResultFoods = searchedResultFoods(between: Section(section))
        return searchedResultFoods.count
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        let searchedResultFoods = searchedResultFoods(between: Section(at: indexPath))
        let foodName = searchedResultFoods[indexPath.row].foodName
        
        var content = UIListContentConfiguration.cell()
        content.text = foodName
        content.textProperties.numberOfLines = 2
        cell.contentConfiguration = content
        return cell
    }
}

extension FoodListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let searchBarText = searchBar.searchTextField.text else { return }
        searchedFoodList = search(for: searchBarText, in: foodList)
        tableView.reloadData()
        searchBar.searchTextField.endEditing(true)
    }
    
    func search(for text: String, in foods: [FoodObject]) -> [FoodObject] {
        let searchedFoods = foods.filter {
            let searchedFood = $0.foodName.contains(text.lowercased())
            return searchedFood
        }
        return searchedFoods
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedFoodList = search(for: searchText, in: foodList)
        tableView.reloadData()
    }
}
