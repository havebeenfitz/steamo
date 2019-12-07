//
//  PlayerStatTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import Charts

class PlayerStatTableViewCell: UITableViewCell {
    
    private let lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.rightAxis.enabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.xAxis.valueFormatter = MinutesXAxisValueFormatter(chart: lineChartView)
        lineChartView.drawBordersEnabled = false
        lineChartView.drawMarkers = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        if #available(iOS 11.0, *) {
            lineChartView.xAxis.labelTextColor = UIColor(named: "Text") ?? .text
            lineChartView.leftAxis.labelTextColor = UIColor(named: "Text") ?? .text
            lineChartView.legend.textColor = UIColor(named: "Text") ?? .text
        } else {
            lineChartView.xAxis.labelTextColor = .text
            lineChartView.leftAxis.labelTextColor = .text
            lineChartView.legend.textColor = .text
        }
        return lineChartView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: StatsSectionViewModelRepresentable, index: Int) {
        guard let viewModel = viewModel as? PlayerStatsSectionViewModel else {
            return
        }
        
        setLineChartData(for: viewModel, index: index)
    }
    
    private func setLineChartData(for viewModel: PlayerStatsSectionViewModel, index: Int) {
        let data = viewModel.lineChartValues(at: index)
        var lineChartEntries: [ChartDataEntry] = []
        
        for key in data.keys.sorted() {
            lineChartEntries.append(ChartDataEntry(x: key, y: data[key] ?? 0))
        }
        
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries)
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.mode = .stepped
        lineChartDataSet.label = viewModel.statDisplayName(at: index)
        lineChartDataSet.drawValuesEnabled = true
        
        if #available(iOS 11.0, *) {
            lineChartDataSet.valueTextColor = NSUIColor(named: "Text") ?? .text
            lineChartDataSet.circleColors = [(NSUIColor(named: "Accent") ?? NSUIColor.accent)]
            lineChartDataSet.colors = [(NSUIColor(named: "Accent") ?? NSUIColor.accent)]
        } else {
            lineChartDataSet.valueTextColor = .text
            lineChartDataSet.circleColors = [NSUIColor.accent]
            lineChartDataSet.colors = [NSUIColor.accent]
        }
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
    
        lineChartView.data = lineChartData
        // Показываем последние n точек
        lineChartView.setVisibleXRangeMaximum(50)
        if let lastEntry = lineChartEntries.last {
            self.lineChartView.moveViewToX(lastEntry.x)
        }
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        selectionStyle = .none
        
        contentView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(150).priority(.init(999))
        }
    }
}
