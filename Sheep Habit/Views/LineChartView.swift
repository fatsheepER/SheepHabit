//
//  LineChartView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/15.
//

import SwiftUI
import Charts

struct DailyHabitsCompletionPercentage: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let date: Date
    let totalCompletion: Int
    let totalRequirement: Int
    
    var percentage: Double {
        if totalRequirement == 0 {
            return 0.0
        }
        return Double(totalCompletion) / Double(totalRequirement)
    }
}

struct HabitLineChart: View {
    let data: [DailyHabitsCompletionPercentage]
    let accentColor: Color
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Rectangle()
                    .frame(width: 20)
                    .opacity(0)
                
                Chart(data) { dailyData in
                    
                    // 0% 标记
                    RuleMark(y: .value("Empty", 0))
                        .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round))
                        .foregroundStyle(.gray)
                        .annotation(position: .top, alignment: .trailing) {
                            Text("0%")
                                .font(.system(size: 8, weight: .bold))
                        }
                    
                    // 100% 标记
                    RuleMark(y: .value("Done", 1))
                        .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
                        .foregroundStyle(.gray)
                        .annotation(position: .overlay, alignment: .trailing) {
                            Text("100%")
                                .font(.system(size: 8, weight: .bold))
                        }
                    
                    // 渐变色块
                    AreaMark(
                        x: .value("Day", dailyData.date),
                        y: .value("Percentage", dailyData.percentage)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(self.chartAreaGradient)
                    
                    // 曲线
                    LineMark(
                        x: .value("Day", dailyData.date),
                        y: .value("Percentage", dailyData.percentage)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(self.accentColor)
                    
                    // 标记点
                    PointMark(
                        x: .value("Day", dailyData.date),
                        y: .value("Percentage", dailyData.percentage)
                    )
                    .symbol {
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                            Circle().strokeBorder(self.accentColor, lineWidth: 1)
                        }
                        .frame(width: 5)
                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { value in
                        AxisValueLabel(format: .dateTime.day().month())
                        AxisTick()
                        AxisGridLine()
                    }
                }
                .chartYAxis(.hidden)
                .chartYScale(domain: 0...1.1)
                .animation(.spring, value: data)
                .frame(width: 700, height: 160)
                
                Rectangle()
                    .frame(width: 20)
                    .opacity(0)
            }
        }
        .defaultScrollAnchor(.trailing)
        .frame(height: 180)
    }
}

extension HabitLineChart {
    var chartAreaGradient: LinearGradient {
        LinearGradient(
            gradient:
                Gradient(
                    colors: [
                        self.accentColor.opacity(0.4),
                        self.accentColor.opacity(0)
                    ]
                ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

//#Preview {
//    HabitLineChart(
//        habits: [Habit(testDate: .now, from: 100), Habit(testDate: .now, from: 100), Habit(testDate: .now, from: 100)]
//    )
//}
