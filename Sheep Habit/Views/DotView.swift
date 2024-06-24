//
//  DotView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/30.
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
    
    // 渐变描边
    var LinearBorderGradient: LinearGradient {
        LinearGradient(
                gradient:
                    Gradient(colors: [
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.0)
                    ]),
               startPoint: .top,
               endPoint: .bottom
        )
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
            .strokeBorder(LinearBorderGradient, lineWidth: size / 8)
            .opacity(isToday ? 1 : 0)
    }
}
