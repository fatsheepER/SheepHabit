//
//  HabitCompleteButtonView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/29.
//

import SwiftUI

struct HabitCompleteButtonView: View {
    let completionPercentage: Double
    let accentColor: Color
    
    var body: some View {
        // 如果已完成
        if (completionPercentage >= 1) {
            completedButton
        }
        // 如果未完成
        else {
            uncompletedButton
        }
    }
}

//MARK: - Extensions
extension HabitCompleteButtonView {
    
    // 未完成状态下的按钮
    var uncompletedButton: some View {
        ZStack {
            // button
            Circle()
                .foregroundStyle(.white.opacity(0.05))
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(0.2), lineWidth: 2)
                }
            
            // completion trim
            Circle()
                .trim(from: 0.0, to: CGFloat(min(completionPercentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .frame(width: 32)
            
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .font(.system(size: 13, weight: .semibold))
        }
        .frame(width: 40)
    }

    // 已完成的按钮
    var completedButton: some View {
        ZStack {
            Circle()
                .foregroundStyle(accentColor)
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(0.2), lineWidth: 2)
                }
            Image(systemName: "checkmark")
                .foregroundStyle(.white)
                .font(.system(size: 13, weight: .semibold))
        }
        .frame(width: 40)
    }
}

//MARK: - Styles
extension HabitCompleteButtonView {
    
    
}

#Preview {
    ZStack {
        RoundedRectangle(cornerRadius: 18)
            .frame(width: 90, height: 90)
            .foregroundStyle(.black)
        HabitCompleteButtonView(completionPercentage: 1, accentColor: .blue)
    }
}
