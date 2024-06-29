//
//  DotsGraphView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import SwiftUI

// 热力图中的点
struct DotView: View {
    var size: CGFloat
    var completionPercentage: Double
    var accentColor: Color
    var isToday: Bool
    
    var body: some View {
        ZStack {
            baisc
            completion
            today
        }
        .frame(width: size, height: size)
        
    }
    
    // 底部基础
    private var baisc: some View {
        RoundedRectangle(cornerRadius: size / 4)
            .foregroundStyle(.white.opacity(0.05))
    }
    
    // 完成情况
    private var completion: some View {
        return (RoundedRectangle(cornerRadius: size / 4)
            .foregroundStyle(accentColor.opacity(completionPercentage)))
    }
    
    // 本日指示框
    private var today: some View {
        RoundedRectangle(cornerRadius: size / 4)
            .strokeBorder(linearBorderGradient, lineWidth: size / 8)
            .opacity(isToday ? 1 : 0)
    }
}

// 点状热力图
struct HabitLandscapeDotsGraph: View {
    var dotSize: CGFloat = 10
    var dotSpacing: CGFloat = 2
    
//    @State var habit: Habit
    @Bindable var habit: Habit
    @State var completionPercentages: [Double] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        // 总共七行
        let rows = Array(repeating: GridItem(.fixed(dotSize), spacing: dotSpacing), count: 7)
        // 日期
        let startWeekday = habit.startWeekday
        let totalDays = habit.totalDays
        
        
        HStack(alignment: .top, spacing: dotSpacing) {
            // 显示星期
            WeekdayIndicatorView(size: dotSize, spacing: dotSpacing)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: dotSpacing) {
                    let totalGrids = totalDays + startWeekday - 1
                    ForEach(0..<totalGrids, id: \.self) { gridIndex in
                        let dayIndex = totalGrids - gridIndex - 1
                        if dayIndex >= 0 && dayIndex < totalDays {
                            let completionPercentage: Double = self.completionPercentages[safe: dayIndex] ?? 0
                            let isToday = (dayIndex == 0)
                            
                            DotView(size: dotSize, completionPercentage: completionPercentage, accentColor: habit.accentColor, isToday: isToday)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.0)
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.3)
                                }
                        }
                        else {
                            DotView(size: dotSize, completionPercentage: 0, accentColor: .white, isToday: false)
                                .opacity(0)
                        }
                    }
                }
                .scrollTargetLayout()
                Spacer()
            }
            .defaultScrollAnchor(.trailing)
            .scrollTargetBehavior(.viewAligned)
        }
        .frame(height: 68)
        .onAppear {
            fetchData()
        }
        .onChange(of: habit.completions) {
            fetchData()
        }
    }
}

extension HabitLandscapeDotsGraph {
    
    func fetchData() {
        isLoading = true
        
        DispatchQueue.global().async {
            let required = Double(habit.requiredCompletion)
            let calendar = Calendar.current
            let todayDate = calendar.startOfDay(for: Date())
            self.completionPercentages = []
            
            let totalDays = habit.totalDays
            for dayOffset in 0..<totalDays {
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: todayDate)
                let value = Double(habit.completions[date!] ?? 0)
                completionPercentages.append(value / required)
//                completionPercentages.insert(value / required, at: 0)
            }
            isLoading = false
        }
    }
    
    func updateFor(dayOffset: Int) {
        let calendar = Calendar.current
        let dateToUpdate = calendar.date(byAdding: .day, value: -dayOffset, to: .now)!
        self.completionPercentages[dayOffset] = Double(habit.completions[dateToUpdate] ?? 0)
    }
}

//#Preview {
//    ZStack {
//        LinearCardGradient
//            .ignoresSafeArea()
//        
//        VStack {
//            DotsGraphView(habit: Habit(testDate: Date(), from: 400))
//        }
//    }
//}
