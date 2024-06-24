//
//  WeekDayIndicatorView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/30.
//

import SwiftUI

// 热力图左侧的星期指示条
struct WeekdayIndicatorView: View {
    let size: CGFloat
    let spacing: CGFloat
    
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .frame(width: size, height: size)
                    .foregroundStyle(.white)
            }
        }
    }
}
