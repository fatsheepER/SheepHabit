//
//  HabitLogRecord.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/17.
//

import SwiftUI

// 显示日志中的单条记录
struct HabitLogRecord: View {
    let date: Date
    let completion: Int
    let requirement: Int
    let accentColor: Color
    
    var body: some View {
        ZStack {
            let percentage = Double(completion) / Double(requirement)
            
            HStack {
                // 日历图标
                Image(systemName: "calendar")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                
                // 日期
                VStack(alignment: .leading) {
                    Text("\(date.formatted(.dateTime.month().day()))")
                        .font(.system(size: 15, weight: .bold))
                    Text("\(date.formatted(.dateTime.weekday()))")
                        .font(.system(size: 12, weight: .regular))
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                //完成情况文字
               HabitCompletionCaption(completion: self.completion, requirement: self.requirement, height: 15)
                
                // 完成按钮
                HabitCompleteButtonView(completionPercentage: percentage, accentColor: self.accentColor)
                    .scaleEffect(0.9)
            }
            
            // 底部分割线
            VStack {
                Spacer()
                
                Capsule()
                    .frame(height: 1)
                    .foregroundStyle(.white.opacity(0.1))
            }
        }
    }
}
