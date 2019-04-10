//
//  HistoryGraph.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 4/10/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

struct HistoryGraphDefaults {
    
    fileprivate static var chartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 40
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: HistoryGraphDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return HistoryGraphDefaults.fontWithSize(11)
    }
    
    static var labelFontSmall: UIFont {
        return HistoryGraphDefaults.fontWithSize(10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return 5
    }
}

class HistoryGraph {
    
    public private(set) var chart: Chart
    
    init(location: Location, frame: CGRect) {
        let labelSettings = ChartLabelSettings(font: HistoryGraphDefaults.labelFont)
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "h:mm a"
        displayFormatter.amSymbol = "am"
        displayFormatter.pmSymbol = "pm"
        
        let calendar = Calendar.current
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        let history = location.averagedOrderedHistory()
        let chartPoints = history.map({ r in HistoryGraph.createChartPoint(date: r.createdOn, percent: Double(r.value), displayFormatter: displayFormatter) })
        let yValues = stride(from: 0, through: 100, by: 10).map({ ChartAxisValuePercent($0, labelSettings: labelSettings) })
        let xValues = history.map({ r in HistoryGraph.createDateAxisValue(r.createdOn, displayFormatter: displayFormatter) })
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Timestamp", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Average Congestion", settings: labelSettings.defaultVertical()))
        let chartFrame = frame
        let chartSettings = HistoryGraphDefaults.chartSettings
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 2, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], delayInit: false)
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.3)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer]
        )
        
        self.chart = chart
    }
    
    private static func createChartPoint(date: Date, percent: Double, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: createDateAxisValue(date, displayFormatter: displayFormatter), y: ChartAxisValuePercent(percent))
    }
    
    private static func createDateAxisValue(_ date: Date, displayFormatter: DateFormatter) -> ChartAxisValue {
        let labelSettings = ChartLabelSettings(font: HistoryGraphDefaults.labelFont, rotation: 60, rotationKeep: .top)
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
}

fileprivate class ChartAxisValuePercent: ChartAxisValueDouble {
    override var description: String {
        return "\(formatter.string(from: NSNumber(value: scalar))!)%"
    }
}
