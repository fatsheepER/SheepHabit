//
//  LineDotsGraph.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/3.
//

import SwiftUI

struct HabitLineDotsGraph: View {
    @State var habit: Habit
    @State var completionPercentages: [Double] = []
    @State var isLoading: Bool = true
    @State var dotCount: Int = 0
    
    let dotSize: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            let width = Int(geo.size.width)
            ZStack {
//                if isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                }
//                else {
//
//                }
                HStack(spacing: self.spacing) {
                    ForEach(0..<self.dotCount, id:\.self) {columnIndex in
                        let index = self.dotCount - columnIndex - 1
                        if let percentage = completionPercentages[safe: index] {
                            DotView(size: self.dotSize, accentColor: habit.accentColor, percentage: percentage, highlighted: index == 0)
                                .id("dotIndex\(index)")
                        }
                        else {
                            DotView(size: self.dotSize, accentColor: habit.accentColor, percentage: 0, highlighted: false)
                                .id("dotIndex\(index)")
                        }
                    }
                }
            }
            .onAppear {
                dotCount = width / Int(dotSize + spacing)
                fetchData(for: dotCount)
            }
            .onChange(of: width) {
                dotCount = width / Int(dotSize + spacing)
                fetchData(for: dotCount)
            }
            .onChange(of: habit.completions) {
                fetchData(for: dotCount)
            }
        }
        .frame(height: 25)
    }
}

// MARK: - Functions and components
extension HabitLineDotsGraph {
    
    func fetchData(for count: Int) {
        isLoading = true
        DispatchQueue.global().async {
            // 需要的完成数量
            let required: Double = Double(habit.requiredCompletion)
            // 日历
            let calendar = Calendar.current
            // 获取今天的日期
            let todayDate = calendar.startOfDay(for: Date())
            // 数据清零
            completionPercentages = []
            
            // 位移查值
            for dayOffset in 0..<count {
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: todayDate)
                let value = Double(habit.completions[date!] ?? 0)
                completionPercentages.append(value / required)
            }
            
            isLoading = false
        }
    }
    
    func updateToday() {
        let newPercentage = habit.todayCompletionPercentage
        completionPercentages[0] = newPercentage
    }
    
    struct DotView: View {
        let size: CGFloat
        let accentColor: Color
        let percentage: Double
        let highlighted: Bool
        
        var body: some View {
            ZStack {
                // 基础色
                RoundedRectangle(cornerRadius: size / 5)
                    .foregroundStyle(.white.opacity(0.1))
                
                // 完成度着色
                RoundedRectangle(cornerRadius: size / 5)
                    .foregroundStyle(self.accentColor.opacity(percentage))
                
                // 今日描边
                RoundedRectangle(cornerRadius: size / 5)
                    .strokeBorder(.white.opacity(0.5), lineWidth: 2)
                    .opacity(highlighted ? 1 : 0)
            }
            .frame(width: size, height: size)
        }
    }
}



extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//#Preview {
//    ZStack {
//        Color.accentBackground
//            .ignoresSafeArea()
//        
//        HabitLineDotsGraph(habit: Habit(testDate: Date(), from: 200), dotSize: 25, spacing: 6)
//    }
//}
