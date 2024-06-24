//
//  HabitView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import SwiftUI
import ContributionChart

struct HabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var habit: Habit
    @State var today: Int = 0
    @State var required: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .foregroundStyle(.white.opacity(0.05))
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(LinearBorderGradient, lineWidth: 1)
                }
            
            VStack() {
                // 标题信息与热力图
                HStack {
                    caption
                    
                    Spacer()
                    
                    HabitCompletionCaption(completion: habit.todayCompletion, requirement: habit.requiredCompletion, height: 20)
                    
                    Button {
                        withAnimation {
                            completeOnce()
                        }
                    } label: {
                        HabitCompleteButtonView(completionPercentage: habit.todayCompletionPercentage, accentColor: habit.accentColor)
                    }
                    .frame(width: 40)
                    .sensoryFeedback(.success, trigger: habit.todayCompletion)
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Label("目前连续打卡：\(habit.currentStreak)次", systemImage: "flame.fill")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    
                    HabitLineDotsGraph(habit: habit, dotSize: 25, spacing: 6)
                }
            }
            .padding(13 )
        }
        .frame(height: 140)
    }
}

//MARK: - Components
extension HabitView {
    
    // 文字描述信息
    var caption: some View {
        HStack() {
            // 图标与圆环
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                    }
                
                Image(systemName: habit.iconSystemName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(habit.accentColor)
            }
            .frame(width: 40, height: 40)
            
            // 名称与描述
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(habit.detail)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.gray)
            }
        }
    }
}

//MARK: - Functions
extension HabitView {
    
    // 完成一次
    func completeOnce() {
        let today = habit.todayCompletion
        let required = habit.requiredCompletion
        
        if today < required {
            habit.todayCompletion = today + 1
        }
        else {
            habit.todayCompletion = 0
        }
        
        habit.calculateStreak()
    }
}

//#Preview {
////    HabitView(habit: Habit(testDate: Date(), from: 400))
//    ZStack {
//        Color(.accentBackground)
//        HabitView(habit: Habit(testDate: Date(), from: 400))
//            .padding()
//    }
//    .ignoresSafeArea()
//    
//}