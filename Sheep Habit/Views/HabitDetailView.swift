//
//  HabitDetailView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/1.
//

import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @State private var recentData: [Int] = []
    @State private var isLoadingRecent: Bool = true
    @State private var isPresentingLogView: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 毛玻璃背景
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.black.opacity(0.4))
            
            
            VStack {
                // 标题与描述
                TitleInformationSection
                    .frame(height: 65)
                
                VStack(spacing: 15) {
                   
                    // 热力图回顾区
                    reviewSection
                        .frame(height: 190)
                    
                    // 连续打卡区
                    streakSection
                        .frame(height: 100)
                    
                    // 日志区
                    recentSection
                }
                .padding(.bottom, 5)
               
           }
           .padding()
            
            // 边框
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(LinearBorderGradient, lineWidth: 1)
        }
    }
}

extension HabitDetailView {
    
    // 信息区背景框
    private var sectionBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(.white.opacity(0.05))
        }
    }
    
    // 标题信息区
    private var TitleInformationSection: some View {
        ZStack {
            
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
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(habit.accentColor)
                }
                .frame(width: 44, height: 44)
                 
                // 名称与描述
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                    Text(habit.detail)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(.gray)
                }
                 
                Spacer()
                
                HabitCompletionCaption(completion: habit.todayCompletion, requirement: habit.requiredCompletion, height: 20)
                
                HabitCompleteButtonView(completionPercentage: habit.todayCompletionPercentage, accentColor: habit.accentColor)
            }
            .padding(.horizontal, 12)
        }
    }
    
    // 回顾信息区
    private var reviewSection: some View {
        ZStack {
            sectionBackground
            
            VStack(spacing: 12) {
                HStack {
                    SectionTitleView(accentColor: habit.accentColor, iconSystemName: "book.pages", title: "回顾", detail: "开始于 \(habit.startDate.formatted(date: .long, time: .omitted))")
                    
                    Spacer()
                }
                .frame(height: 45)
                
                HStack(spacing: 0) {
                    Image(systemName: "checkmark.circle")
                        .fontWeight(.bold)
                    
                    Text("在过去的\(habit.totalDays)天里完成了 ")
                    
                    ShiningTextView(content: "\(habit.doneDays)", size: 12, accentColor: habit.accentColor, weight: .semibold)
                    
                    Text(" 天｜完成率 ")
                    
                    ShiningTextView(content: String(format: "%.1f", habit.wholeCompletionPercentage * 100), size: 12, accentColor: habit.accentColor, weight: .semibold)
                    
                    Text(" %")
                    
                    Spacer()
                }
                .font(.system(size: 12, weight: .medium))
                
                HabitLandscapeDotsDraph(habit: habit)
                    .padding(.top, 4)
            }
            .padding()
        }
    }
    
    // 最近记录信息区
    private var recentSection: some View {
        ZStack {
            sectionBackground
            
            VStack {
                
                // 标题
                HStack {
                    SectionTitleView(accentColor: habit.accentColor, iconSystemName: "arrowshape.turn.up.backward.circle", title: "修改", detail: "最近七天")
                    Spacer()
                }
                
                Spacer()
                
                // 最近七天的记录
                if !isPresentingLogView {
                    VStack() {
                        
                        let requirement = habit.requiredCompletion
                        let startDate = habit.startDate
                        let accentColor = habit.accentColor
                        ForEach(0..<7, id: \.self) { index in
                            let date = Calendar.current.date(byAdding: .day, value: -index, to: .now)!
                            
                            if date >= startDate {
                                Button {
                                    completeOnce(for: index)
                                    fetchData()
                                } label: {
                                    HabitLogRecord(date: date, completion: self.recentData[safe: index] ?? 0, requirement: requirement, accentColor: accentColor)
                                }
                                .frame(height: 50)
                            }
                            
                        }
                        
                        // 查看日志
                        Button {
                            withAnimation {
                                self.isPresentingLogView = true
                            }
                        } label: {
                            NavigationButton(title: "查看日志", iconSystemName: "tray.full", height: 45, cornerRadius: 6, fontSize: 15)
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        fetchData()
                    }
                }
                else {
                    HabitLog(habit: self.habit, isPresenting: $isPresentingLogView)
                        .frame(maxWidth: .infinity)
                }

                
            }
            .padding()
        }
    }
    
    // 坚持信息区
    private var streakSection: some View {
        ZStack {
            sectionBackground
            HStack {
                SectionTitleView(accentColor: habit.accentColor, iconSystemName: "flame", title: "坚持", detail: "连续打卡记录")
                    .frame(width: 116)
                Spacer()
                
                VStack {
                    Text("直到今天")
                        .font(.system(size: 12, weight: .medium))
                    Text("\(habit.currentStreak)天")
                        .font(.system(size: 30, weight: .black))
                }
                
                VStack {
                    Text("最长记录")
                        .font(.system(size: 12, weight: .medium))
                    ShiningTextView(content: "\(habit.longestStreak)天", size: 30, accentColor: habit.accentColor, weight: .black)
                }
                .padding(.leading, 32)
            }
            .padding(.horizontal)
        }
    }
    
    func fetchData() {
        isLoadingRecent = true
        
        DispatchQueue.global().async {
            // 日历
            let calendar = Calendar.current
            // 获取今天的日期
            let todayDate = calendar.startOfDay(for: Date())
            // 数据清零
            recentData = []
            
            // 位移查值
            for dayOffset in 0..<7 {
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: todayDate)!
                
                // 习惯开始前的日期不可修改
                if (date < habit.startDate) {
                    break
                }
                
                let value = habit.completions[date] ?? 0
                recentData.append(value)
            }
            
            isLoadingRecent = false
        }
    }
    
    // 完成一次
    func completeOnce(for index: Int) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.date(byAdding: .day, value: -index, to: today)!
        
        let completion = habit.completions[date] ?? 0
        let newValue = completion + 1
        let required = habit.requiredCompletion
        
        // 归零
        if newValue > required {
            habit.completions[date] = 0
            habit.calculateStreak()
            return
        }
        
        habit.completions[date] = newValue
        
        // 完成 新纪录
        if newValue == required {
            habit.calculateStreak()
        }
    }
}

// 呼出视图的操作按钮
struct NavigationButton: View {
    let title: String
    let iconSystemName: String
    let height: CGFloat
    let cornerRadius: CGFloat
    let fontSize: CGFloat
    
    var body: some View {
        ZStack {
            // 背景
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .foregroundStyle(.white.opacity(0.05))
            
            // 内容
            HStack {
                Label(self.title, systemImage: self.iconSystemName)
                    .font(.system(size: self.fontSize, weight: .medium))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: self.fontSize, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
            
            // 边框
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        }
        .frame(height: self.height)
    }
}

// 底部的渐变操作按钮
struct DetailButtonView: View {
    let labelSystemName: String
    let labelTextContent: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(color.opacity(0.1))
            
            Label(labelTextContent, systemImage: labelSystemName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        }
        .frame(height: 50)
    }
}

struct SectionTitleView: View {
    let accentColor: Color
    let iconSystemName: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 45)
                    .foregroundStyle(accentColor.opacity(0.12))
                
                Image(systemName: iconSystemName)
                    .foregroundStyle(accentColor)
                    .font(.system(size: 20, weight: .bold))
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                
                Text(detail)
                    .font(.system(size: 10, weight: .medium))
            }
        }
    }
}

struct ShiningTextView: View {
    let content: String
    let size: CGFloat
    let accentColor: Color
    let weight: Font.Weight
    
    var body: some View {
        ZStack {
            Text(content)
                .font(.system(size: size, weight: weight))
                .foregroundStyle(accentColor)
                .blur(radius: 3)
            
            Text(content)
                .font(.system(size: size, weight: weight))
                .foregroundStyle(accentColor)
        }
    }
}

//#Preview {
//    ZStack {
//        Color.accentBackground
//            .ignoresSafeArea()
//        HabitDetailView(habit: Habit(testDate: Date(), from: 300))
//    }
//}
