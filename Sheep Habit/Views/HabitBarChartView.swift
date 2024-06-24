//
//  HabitBarChartView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/12.
//

import SwiftUI
import Charts

struct HabitBarChartView: View {
    @State var habit: Habit = Habit(testDate: .now, from: 200, color: .blue)
    var data: [(key: Date, value: Int)] {
        habit.completions.sorted { $0.key < $1.key }
    }
    
    var body: some View {
        VStack {
            Chart {
                
                ForEach(data, id: \.key) { key, value in
                    BarMark(x: .value("Month", key, unit: .month),
                            y: .value("Completion", value)
                    )
                    .foregroundStyle(habit.accentColor)
                    .cornerRadius(3)
                }
                
                RuleMark(y: .value("Goal", 50))
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, dash: [5]))
                    .foregroundStyle(.secondary)
            }
            .frame(height: 200)
            .chartPlotStyle { plotContent in
                plotContent.background(habit.accentColor.gradient.opacity(0.2))
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(values: data.map { $0.key }) { date in
                    AxisValueLabel(format: .dateTime.month(.narrow) )
                }
            }
        }
    }
}

#Preview {
    HabitBarChartView()
}
