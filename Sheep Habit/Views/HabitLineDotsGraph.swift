//
//  LineDotsGraph.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/3.
//

import SwiftUI

struct HabitLineDotsGraph: View {
    let percentages: [Double]
    let accentColor: Color
    let weekday: Int
    
    var body: some View {
        HStack(spacing: 5) {
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 0] ?? 0,
                isToday: weekday == 1,
                weekday: "S")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 1] ?? 0,
                isToday: weekday == 2,
                weekday: "M")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 2] ?? 0,
                isToday: weekday == 3,
                weekday: "T")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 3] ?? 0,
                isToday: weekday == 4,
                weekday: "W")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 4] ?? 0,
                isToday: weekday == 5,
                weekday: "T")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 5] ?? 0,
                isToday: weekday == 6,
                weekday: "F")
            
            StripeIndicator(
                accentColor: accentColor,
                percentage: percentages[safe: 6] ?? 0,
                isToday: weekday == 7,
                weekday: "S")
        }
    }
}

// MARK: - Functions and components
extension HabitLineDotsGraph {
    
    struct StripeIndicator: View {
        let accentColor: Color
        let percentage: Double
        let isToday: Bool
        let weekday: String
        
        var body: some View {
            VStack {
                
                Text(weekday)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(isToday ? 1 : 0.5)
                
                Spacer()
                
                ZStack {
                    
                    // 底部基础色层
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundStyle(.white.opacity(0.2))
                    
                    // 发光色层
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundStyle(accentColor)
                        .blur(radius: 5)
                        .opacity(percentage >= 1 ? 1 : 0)
                    
                    // 完成度色层
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundStyle(accentColor.opacity(percentage))
                }
                .frame(height: 6)
            }
            .frame(height: 20)
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
