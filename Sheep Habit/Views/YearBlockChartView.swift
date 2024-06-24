//
//  YearBlockChartView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/18.
//

import SwiftUI
import Charts

struct MonthCompletionRecord: Identifiable {
    let id: String = UUID().uuidString
    let monthIndex: Int
    let completionCount: Int
}

struct YearBlockChart: View {
    let records: [MonthCompletionRecord]
    let accentColor: Color
    
    var body: some View {
        Chart(records) { record in
            BarMark(x: .value("Month", record.monthIndex + 1),
                    y: .value("Count", record.completionCount),
                    width: .fixed(5)
            )
            .foregroundStyle(accentColor.gradient)
        }
        .chartXScale(domain: 1...12)
        .chartXAxis {
            AxisMarks(preset: .aligned, values: Array(1...12)) { value in
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let intValue = value.as(Int.self), intValue != 0 {
                        Text("\(intValue)")
                    }
                }
            }
        }
    }
}

#Preview {
    YearBlockChart(
        records: [
            MonthCompletionRecord(monthIndex: 0, completionCount: 10),
            MonthCompletionRecord(monthIndex: 1, completionCount: 30),
            MonthCompletionRecord(monthIndex: 2, completionCount: 10),
            MonthCompletionRecord(monthIndex: 3, completionCount: 10),
            MonthCompletionRecord(monthIndex: 4, completionCount: 40),
            MonthCompletionRecord(monthIndex: 5, completionCount: 20),
            MonthCompletionRecord(monthIndex: 6, completionCount: 30),
            MonthCompletionRecord(monthIndex: 7, completionCount: 50),
            MonthCompletionRecord(monthIndex: 8, completionCount: 10),
            MonthCompletionRecord(monthIndex: 9, completionCount: 20),
            MonthCompletionRecord(monthIndex: 10, completionCount: 40),
            MonthCompletionRecord(monthIndex: 11, completionCount: 10)
        ],
        accentColor: .blue
    )
    .frame(width: 300, height: 90)
}
