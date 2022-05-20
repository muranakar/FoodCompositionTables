////
////  ResultViewController.swift
////  FoodCompositionTables
////
////  Created by 山田　天星 on 2022/04/25.
////

import UIKit
import Charts

final class ResultViewController: UIViewController {
    //これモデル側に寄せられる？
    var selectFoodTableUseCase = SelectFoodsTableUseCase()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartsView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "resultCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        pieChartsView.centerText = "PFC balance"
        reloadPFCPieChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadPFCPieChart()
        tableView.reloadData()
    }

    func reloadPFCPieChart() {
        let energy = Double(selectFoodTableUseCase.totalEnergy)
        let proteinRatio = selectFoodTableUseCase.totalProtein * 4 / energy * 100
        let fatRatio = selectFoodTableUseCase.totalFat  * 4 / energy * 100
        let carbohydrateRatio = selectFoodTableUseCase.totalCarbohydrate  * 4 / energy * 100

        let pieChartsDataEnry = [
            PieChartDataEntry(value: Double(proteinRatio), label: "protein"),
            PieChartDataEntry(value: Double(fatRatio), label: "fat"),
            PieChartDataEntry(value: Double(carbohydrateRatio), label: "carbo")
        ]
        var dataSet = PieChartDataSet()
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        pieChartsView
            .data?
            .setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartsView
            .usePercentValuesEnabled = true
//        view.addSubview(self.pieChartsView)
        dataSet = PieChartDataSet(entries: pieChartsDataEnry, label: "PFCバランス")
        dataSet.colors = ChartColorTemplates.liberty()
        dataSet.valueTextColor = UIColor.black
        dataSet.entryLabelColor = UIColor.black
        self.pieChartsView.data = PieChartData(dataSet: dataSet)
    }
}

extension ResultViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodCompositionType.resultCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") else { fatalError() }
        //栄養素名称
        let compositionType = FoodCompositionType.resultCases[indexPath.row]
        let compositionName = compositionType.nameString
        //栄養素量
        let compositionValue = selectFoodTableUseCase.getCompositionValueString(of: compositionType)

        var content = UIListContentConfiguration.valueCell()
        content.text = compositionName
        content.secondaryText = compositionValue
        cell.contentConfiguration = content
        return cell
    }
}
