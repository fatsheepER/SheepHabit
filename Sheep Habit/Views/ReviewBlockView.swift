//
//  ReviewBlockView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/18.
//

import SwiftUI
import Charts

struct TotalUsageTimeBlock: View {
    let days: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white.opacity(0.05))
            
            VStack {
                Text("已经使用")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("Sheep Habit")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text("\(self.days)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("天")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(linearBorderGradient, lineWidth: 1)
        }
    }
}

enum StreakBlockType {
    case currentStreak
    case longestStreak
}

struct StreakBlock: View {
    let type: StreakBlockType
    let days: Int
    let accentColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white.opacity(0.05))
            
            HStack {
                VStack(alignment: .leading) {
                    switch type {
                    case .currentStreak:
                        Text("当前")
                            .foregroundStyle(.white.opacity(0.5))
                    case .longestStreak:
                        Text("最长")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Text("完美一天")
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("连续记录")
                        .foregroundStyle(.white.opacity(0.5))
                        
                }
                .font(.system(size: 15, weight: .medium))
                
                Spacer()
                
                Text("\(self.days)")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(accentColor)
                    .opacity(self.type == .currentStreak ? 1 : 0.5)
                
                Text("天")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
            }
            .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(linearBorderGradient, lineWidth: 1)
        }
    }
}

struct YearSelectButton: View {
    let year: Int
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white.opacity(0.2))
                .opacity(isSelected ? 1 : 0)
            
            Text(String(year))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
        }
        .frame(width: 54, height: 24)
    }
}

#Preview {
    ZStack {
        Color.accentBackground.ignoresSafeArea()
        
        VStack {
            TotalUsageTimeBlock(days: 399)
                .frame(width: 190, height: 190)
        }
    }
}
