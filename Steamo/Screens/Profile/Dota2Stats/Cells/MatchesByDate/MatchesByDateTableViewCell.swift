//
//  MatchesByDateTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 04.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Charts
import UIKit

class MatchesByDateTableViewCell: UITableViewCell {
    
    fileprivate var viewModel: MatchesByDateSectionViewModel?
    
    private lazy var barChart: BarChartView = {
        let barChartView = BarChartView()
        barChartView.fitBars = true
        barChartView.rightAxis.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        if #available(iOS 11.0, *) {
            barChartView.xAxis.labelTextColor = UIColor(named: "Text") ?? .text
            barChartView.leftAxis.labelTextColor = UIColor(named: "Text") ?? .text
            barChartView.legend.textColor = UIColor(named: "Text") ?? .text
        } else {
            barChartView.xAxis.labelTextColor = .text
            barChartView.leftAxis.labelTextColor = .text
            barChartView.legend.textColor = .text
        }
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.granularity = 1
        
        barChartView.delegate = self
        return barChartView
    }()
    
    private lazy var daysValueFormatter = DayAxisValueFormatter(chart: barChart)
    private lazy var hoursValueFormatter = HoursXAxisValueFormatter(chart: barChart)
    
    fileprivate var isDaysDataSet: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: Dota2StatsSectionViewModelRepresentable) {
        guard let viewModel = viewModel as? MatchesByDateSectionViewModel else {
            return
        }
        self.viewModel = viewModel
        
        setBarChartData(with: viewModel)
    }
    
    fileprivate func setBarChartData(with viewModel: MatchesByDateSectionViewModel) {
        let wonByDay = viewModel.matchesBy(.day, result: .won)
        let lostByDay = viewModel.matchesBy(.day, result: .lost)
        
        var wonEntries: [BarChartDataEntry] = []
        // Сортируем, чтобы нормально зумилось, иначе бары продпадают
        // https://github.com/danielgindi/Charts/issues/2240
        for key in wonByDay.keys.sorted() {
            let entry = BarChartDataEntry(x: key, y: wonByDay[key] ?? 0)
            wonEntries.append(entry)
        }
        
        var lostEntries: [BarChartDataEntry] = []
        for key in lostByDay.keys.sorted() {
            let entry = BarChartDataEntry(x: key, y: lostByDay[key] ?? 0)
            lostEntries.append(entry)
        }
        
        let wonDataSet = BarChartDataSet(entries: wonEntries, label: "Won")
        wonDataSet.colors = [NSUIColor.systemGreen]
        wonDataSet.drawValuesEnabled = false
        
        let lostDataSet = BarChartDataSet(entries: lostEntries, label: "Lost")
        lostDataSet.colors = [NSUIColor.systemRed]
        lostDataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [wonDataSet, lostDataSet])
        
        barChart.xAxis.valueFormatter = daysValueFormatter
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = 1
        barChart.data = data
        barChart.animate(xAxisDuration: 0.3, yAxisDuration: 0.3, easingOption: .easeOutSine)
        
        isDaysDataSet = true
    }
    
    fileprivate func setGranularBarChartData(with viewModel: MatchesByDateSectionViewModel) {
        let wonByHour = viewModel.matchesBy(.hour, result: .won)
        let lostByHour = viewModel.matchesBy(.hour, result: .lost)
        
        var wonEntries: [BarChartDataEntry] = []
        // Сортируем, чтобы нормально зумилось, иначе бары продпадают
        // https://github.com/danielgindi/Charts/issues/2240
        for key in wonByHour.keys.sorted() {
            let entry = BarChartDataEntry(x: key, y: wonByHour[key] ?? 0)
            wonEntries.append(entry)
        }
        
        var lostEntries: [BarChartDataEntry] = []
        for key in lostByHour.keys.sorted() {
            let entry = BarChartDataEntry(x: key, y: lostByHour[key] ?? 0)
            lostEntries.append(entry)
        }
        
        let wonDataSet = BarChartDataSet(entries: wonEntries, label: "Won")
        wonDataSet.colors = [NSUIColor.systemGreen]
        wonDataSet.drawValuesEnabled = false
        let lostDataSet = BarChartDataSet(entries: lostEntries, label: "Lost")
        lostDataSet.colors = [NSUIColor.systemRed]
        lostDataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [wonDataSet, lostDataSet])
        barChart.xAxis.valueFormatter = hoursValueFormatter
        barChart.data = data
        
        isDaysDataSet = false
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(barChart)
        barChart.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(20)
            make.height.equalTo(400).priority(.init(999))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        barChart.data = nil
        isDaysDataSet = false
    }
}

extension MatchesByDateTableViewCell: ChartViewDelegate {

    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        guard let viewModel = viewModel, let barChartView = chartView as? BarChartView else {
            return
        }
        // Абсолютное расстояние между двумя крайними точками на графике
        let xAxisEntryApproximity = abs(((barChartView.xAxis.entries.first ?? 0) - (barChartView.xAxis.entries.last ?? 0)))
        
        if xAxisEntryApproximity < 2, scaleX > 1 { // Подменяем дату для барчарта, когда зум достаточно близкий
            setGranularBarChartData(with: viewModel)
        } else if scaleX < 1, xAxisEntryApproximity >= 24, !isDaysDataSet { // Ставим обратно, если отдаляем
            setBarChartData(with: viewModel)
        }
    }
}
