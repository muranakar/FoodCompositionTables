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
// TODO: リストを表示する際に読み込みが遅れるのを直したい
class FoodListViewController: UIViewController, FoodRegistrationDelegate {
    weak var delegate: FoodListViewTransitonDelegate?
    
    private var selectingFood: FoodObject?
    private var foodListAll: [FoodObject] {
        FoodCompositionTableUseCase().foodTable
    }
    private var foodListForTableView: [[FoodObject]] = []
    
    @IBOutlet private weak var foodSearchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchSettingButton: UIButton!

    // 検索の際に用いるプロパティ
    var searchTimer: Timer?
    
    // 検索時のTableViewを覆い隠す用
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var contentsCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        //        setupSearchBar()
        configureSearchBar()
        searchSettingButton
            .addTarget(
                self,
                action: #selector(searchSettingButtonTapped),
                for: .touchUpInside)
        foodListForTableView = convertAllFoodObjectToArray()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let foodCompositonVC = segue.destination as? FoodCompositionViewController else { return }
        guard let selectingFood = selectingFood else { return }
        foodCompositonVC.selectFood = selectingFood
        foodCompositonVC.delegate = self
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
                storyboard?.instantiateViewController(
                    withIdentifier: "SearchSettingViewController"
                ) else { return }
        
        if #available(iOS 15.0, *) {
            if let sheet = searchSettingVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
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

    // TableViewに表示するために、全ての食品成分表のデータを、二次元配列に置き換える。
    func convertAllFoodObjectToArray() -> [[FoodObject]] {
        var arrayAllSection: [[FoodObject]] = []
        FoodCategoryType.allCases.forEach { foodCategoryType in
            var arraySection: [FoodObject] = []
            foodListAll.forEach { foodObject in
                if foodObject.category == foodCategoryType.name {
                    arraySection.append(foodObject)
                }
            }
            arrayAllSection.append(arraySection)
        }
        return arrayAllSection
    }
    // TableViewに表示するために、検索条件に当てはまる食品成分表のデータを、二次元配列に置き換える。
    func convertSerchedFoodObjectToArray(for text: String) -> [[FoodObject]] {
        var arrayAllSection: [[FoodObject]] = []
        FoodCategoryType.allCases.forEach { foodCategoryType in
            var arraySection: [FoodObject] = []
            foodListAll.forEach { foodObject in
                // ここで文字列の条件指定をしている。
                if foodObject.category == foodCategoryType.name
                    && foodObject.foodName.contains(text.lowercased()) {
                    arraySection.append(foodObject)
                }
            }
            if arraySection.count != 0 {
                arrayAllSection.append(arraySection)
            }
        }
        return arrayAllSection
    }
}

extension FoodListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectingFood = foodListForTableView[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "toFoodCompositionVC", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        foodListForTableView.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var array: [String] = []
        foodListForTableView.forEach {
            array.append($0[0].category)
        }
        return array[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodListForTableView[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        let foodName = foodListForTableView[indexPath.section][indexPath.row].foodName

        var content = UIListContentConfiguration.cell()
        content.text = foodName
        content.textProperties.numberOfLines = 2
        cell.contentConfiguration = content
        return cell
    }
}

extension FoodListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        view.endEditing(true)
        //        guard let searchBarText = searchBar.searchTextField.text else { return }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
        //            self?.foodListForTableView = (self?.convertSerchedFoodObjectToArray(for: searchBarText))!
        //            self?.tableView.reloadData()
        //        }
        //        searchBar.searchTextField.endEditing(true)
    }

    // 書き方悪いと思いますが、UI部分が止まらないように、実装してみました。
    // Rxで実装可能だとおもいますが、Rxを用いずに実装する練習のため、実装してみました。
    // Rxでいうと、debounceTimeの実装に近いです。 参考記事：https://blog.tarkalabs.com/all-about-debounce-4-ways-to-achieve-debounce-in-swift-e8f8ce22f544

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let dispatchQueue = DispatchQueue.global()
        // 変数の宣言の部分で、searchTimerを宣言しています。
        searchTimer?.invalidate()
        // withTimeIntervalの部分で、○○秒入力がなければ、下の処理が行われない実装に
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {[weak self] _ in
            if searchText == "" {
                // 読込はメインスレッドを用いない
                dispatchQueue.async {[weak self] in
                    self?.foodListForTableView = (self?.convertAllFoodObjectToArray())!
                    // テーブルビューの更新はメインスレッドを用いる
                    DispatchQueue.main.async {[weak self] in
                        self?.tableView.reloadData()
                    }
                }
            } else {
                // TODO: 入力数値に検索結果が見つからない場合に、「見つかりませんでした」の表示実装してみてもよいかも。
                // TODO: 読込中のラベルOrインジケーター表示もありかも。
                // 読込はメインスレッドを用いない
                dispatchQueue.async {[weak self] in
                    self?.foodListForTableView = (self?.convertSerchedFoodObjectToArray(for: searchText))!
                    // テーブルビューの更新はメインスレッドを用いる
                    DispatchQueue.main.async {[weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        })
    }
}
