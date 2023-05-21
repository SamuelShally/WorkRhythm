//
//  GraphingTests.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 7/26/21.
//

import SwiftUI
import Charts

struct GraphingTests: UIViewRepresentable
{
    let rawData : [(String, Int)]
    let label : String
    
    func makeUIView(context: Context) -> BarChartView
    {
        return BarChartView()
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context)
    {
        
        let entries = createData()
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = self.label
        
        uiView.noDataText = "No Current Data"
        uiView.rightAxis.enabled = false
                
        uiView.setScaleEnabled(false)
        
        uiView.isUserInteractionEnabled = false
        
        uiView.data = BarChartData(dataSet: dataSet)
        
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        
        uiView.notifyDataSetChanged()
        
    }
    
    func createData() -> [BarChartDataEntry]
    {
        var barData : [BarChartDataEntry] = []
        
        var xValue = 0
        
        for point in rawData
        {
            let barPoint = BarChartDataEntry(x: Double(xValue), y: Double(point.1))
            
            barData.append(barPoint)
            
            xValue += 1
        }
        
        return barData
    }
    
    func formatDataSet(dataSet: BarChartDataSet)
    {
        dataSet.colors = [.orange]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis)
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        
        leftAxis.granularity = 1
        leftAxis.granularityEnabled = true
        
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis)
    {
        let axisArray = getAxisArray()
        
        xAxis.valueFormatter = IndexAxisValueFormatter(values: axisArray)
        
        xAxis.labelPosition = .bottom
        
        xAxis.granularity = 1
        xAxis.granularityEnabled = true
    }
    
    func formatYAxis(yAxis : YAxis)
    {
        
    }
    
    func getAxisArray() -> [String]
    {
        var axisArray : [String] = []
        
        for value in rawData
        {
            axisArray.append(value.0)
        }
    
        return axisArray
    }
    
    func formatLegend(legend : Legend)
    {
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        
    }

}

struct GraphingTest_Previews : PreviewProvider
{
    static var previews: some View
    {
        GraphingTests(rawData: [("Jan", 1), ("Feb", 2), ("Mar", 3), ("Apr", 4), ("May", 5), ("Jun", 6), ("Jul", 7), ("Aug", 8), ("Sep", 9), ("Oct", 10), ("Nov", 11), ("Dec", 12)], label: "This Year" )
    }
    
}
