//
//  HabitLogView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/17.
//

import SwiftUI

// 可选月份结
struct MonthOption: Identifiable {
    let id: String = UUID().uuidString
    let startOfMonth: Date
    let tag: Int
}

struct DayOption: Identifiable {
    let id: String = UUID().uuidString
    let startOfDay: Date
    let value: Int
    let index: Int
}

struct HabitLog: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var habit: Habit
    @Binding var isPresenting: Bool
    @State var selectedTag: Int = 0
    @State var validMonths: [MonthOption] = []
    @State var recordsOfMonth: [DayOption] = []
    
    var body: some View {
        VStack {
            let calendar = Calendar.current
            let currentMonth = calendar.dateInterval(of: .month, for: .now)!.start
            let selectedMonth = calendar.date(byAdding: .month, value: -selectedTag, to: currentMonth)!
            let requirement = habit.requiredCompletion
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(recordsOfMonth) { record in
                    Button {
                        completeOnceFor(monthIndex: selectedTag, dayIndex: record.index)
                        fetchRecordOfMonth()
                    } label: {
                        HabitLogRecord(date: record.startOfDay, completion: record.value, requirement: requirement, accentColor: habit.accentColor)
                    }
                    .frame(height: 50)
                }
            }
            
            VStack {
                
                // Stepper
                ZStack {
                    
                    stepperBackground
                    
                    // Menu Button
                    Menu {
                        Picker(selection: $selectedTag) {
                            ForEach(validMonths) { option in
                                Text("\(option.startOfMonth.formatted(.dateTime.year().month()))")
                                    .tag(option.tag)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                        }
                    } label: {
                        Text("\(selectedMonth.formatted(.dateTime.year().month()))")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .animation(.none, value: self.selectedTag)
                    }
                    
                    // Next and previous button
                    HStack {
                        Button {
                            toLastMonth()
                        } label: {
                            Image(systemName: "minus")
                        }
                        
                        Spacer()
                        
                        Button {
                            toNextMonth()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                }
                .frame(height: 40)
                
                // Done Button
                Button {
                    withAnimation {
                        self.isPresenting = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(habit.accentColor.opacity(0.2))
                        
                        Text("完成")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(LinearBorderGradient, lineWidth: 1)
                    }
                }
                .frame(height: 40)
            }
            
            
        }
        .onAppear {
            fetchValidMonths()
            fetchRecordOfMonth()
        }
        .onChange(of: selectedTag) { fetchRecordOfMonth() }
    }
}

// MARK: - Functions
extension HabitLog {
    
    // 下一月
    func toNextMonth() {
        if self.selectedTag > 0 {
            withAnimation {
                self.selectedTag -= 1
            }
        }
    }
    
    // 上一月
    func toLastMonth() {
        if self.selectedTag < self.validMonths.count - 1 {
            withAnimation {
                self.selectedTag += 1
            }
        }
    }
    
    // 获取合法的月份
    func fetchValidMonths() {
        let calendar = Calendar.current
        let startDate = habit.startDate
        
        // 习惯开始的那一月
        let startOfMonth = calendar.dateInterval(of: .month, for: startDate)!.start
        
        // 从本月开始
        var validMonth = calendar.dateInterval(of: .month, for: .now)!.start
        var tag = 0
        
        // 添加
        self.validMonths = []
        while (validMonth >= startOfMonth) {
            self.validMonths.append(MonthOption(startOfMonth: validMonth, tag: tag))
            validMonth = calendar.date(byAdding: .month, value: -1, to: validMonth)!
            tag = tag + 1
        }
    }
    
    // 获取当前月份的所有记录
    func fetchRecordOfMonth() {
        let calendar = Calendar.current
        let currentMonth = calendar.dateInterval(of: .month, for: .now)!.start
        let habitStartDate = habit.startDate
        let selectedMonth = calendar.date(byAdding: .month, value: -self.selectedTag, to: currentMonth)!
        
        let dayCount = calendar.range(of: .day, in: .month, for: selectedMonth)!.count
        
        self.recordsOfMonth = []
        var dayIndex = 0
        while dayIndex < dayCount {
            let date = calendar.date(byAdding: .day, value: dayIndex, to: selectedMonth)!
            
            if date >= habitStartDate && date <= .now {
                let dayValue = habit.completions[date] ?? 0
                let newRecord = DayOption(startOfDay: date, value: dayValue, index: dayIndex)
                recordsOfMonth.append(newRecord)
            }
            
            dayIndex += 1
        }
    }
    
    func completeOnceFor(monthIndex: Int, dayIndex: Int) {
        let calendar = Calendar.current
        let currentMonth = calendar.dateInterval(of: .month, for: .now)!.start
        let selectedMonth = calendar.date(byAdding: .month, value: -monthIndex, to: currentMonth)!
        let date = calendar.date(byAdding: .day, value: dayIndex, to: selectedMonth)!
        
        let completion = habit.completions[date] ?? 0
        let newValue = completion + 1
        let requirement = habit.requiredCompletion
        
        if newValue > requirement {
            habit.completions[date] = 0
            habit.calculateStreak()
            try! modelContext.save()
            return
        }
        
        habit.completions[date] = newValue
        
        if newValue == requirement {
            habit.calculateStreak()
            
        }
        try! modelContext.save()
    }
}

// MARK: - Components
extension HabitLog {
    
    private var stepperBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white.opacity(0.1))
            
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(LinearBorderGradient, lineWidth: 1)
        }
    }
}

//#Preview {
//    ZStack {
//        Color.accentBackground
//            .ignoresSafeArea()
//        
//        HabitLog(habit: Habit(testDate: .now, from: 200))
//    }
//    .preferredColorScheme(.dark)
//}

