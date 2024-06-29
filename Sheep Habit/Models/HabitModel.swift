//
//  HabitModel.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Habit: Identifiable {
    //MARK: - 存储属性
    
    // 基础信息
    var id = UUID()
    var order: Int = 0
    var name: String = "新的习惯"
    var detail: String = "描述信息"
    var iconSystemName: String = "curlybraces"
    // - 是否归档
    var isArchieved: Bool = false
    
    // Accent Color
    var accentColorString: String = "59CAFF"
    
    // 完成情况
    var requiredCompletion: Int = 1
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    
    // 日期
    var startDate: Date // 起始日期
    var endDate: Date? // 结束日期（不一定要有
    
    // 数据
    var completions: [Date: Int] = [:] // 完成的日期
    
    //MARK: - 计算属性
    // 主题色
    var accentColor: Color {
        get {
            return Color(hex: accentColorString)!
        }
        set {
            accentColorString = newValue.toHex()!
        }
    }
    
    // 今天的完成次数
    var todayCompletion: Int {
        get {
            let today = Calendar.current.startOfDay(for: Date())
            let completionToday = self.completions.first { (date, _) in
                Calendar.current.isDate(date, inSameDayAs: today)
            }?.value
            return completionToday ?? 0
        }
        
        set {
            let today = Calendar.current.startOfDay(for: Date())
            self.completions[today] = newValue
        }
    }
    
    // 习惯开始时的星期
    var startWeekday: Int {
        return Calendar.current.component(.weekday, from: startDate)
    }
    
    // 习惯执行的总天数
    var totalDays: Int {
        let dayComponent = Calendar.current.dateComponents([.day], from: self.startDate, to: .now).day ?? 0
        return dayComponent + 1
    }
    
    // 今天的完成百分比
    var todayCompletionPercentage:Double {
        return Double(todayCompletion) / Double(requiredCompletion)
    }
    
    var doneDays: Int {
        return completions.filter { $0.value == self.requiredCompletion }.count
    }
    
    var wholeCompletionPercentage: Double {
        return Double(doneDays) / Double(totalDays)
    }
    
    //MARK: - INIT
    
    init(name: String, detail: String, iconSystemName: String, requiredCompletion: Int, currentStreak: Int, longestStreak: Int, startDate: Date, endDate: Date? = nil) {
        self.name = name
        self.detail = detail
        self.iconSystemName = iconSystemName
        self.requiredCompletion = requiredCompletion
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(name: String, detail: String, iconSystemName: String, accentColor: Color, requiredCompletion: Int) {
        self.name = name
        self.detail = detail
        self.iconSystemName = iconSystemName
        self.requiredCompletion = requiredCompletion
        self.currentStreak = 0
        self.longestStreak = 0
        self.startDate = Calendar.current.startOfDay(for: Date())
        self.todayCompletion = 0
        self.endDate = nil
        self.accentColor = accentColor
    }
    
    // 生成距今 n 天的测试数据
    init(testDate: Date, from: Int, color: Color) {
        self.name = "测试习惯"
        self.detail = "就是喜欢测试嗷"
        var dateComponents = DateComponents()
        dateComponents.day = -from
        
        let today = Calendar.current.startOfDay(for: testDate)
        guard let TwoHundredDaysAgo = Calendar.current.date(byAdding: dateComponents, to: today) else {
            self.startDate = Date(timeIntervalSince1970: 0)
            return
        }
        
        self.startDate = TwoHundredDaysAgo
        self.requiredCompletion = 5
        
        for dayIndex in 0...from {
            if let date = Calendar.current.date(byAdding: .day, value: dayIndex, to: startDate) {
                let value = Int.random(in: 0...self.requiredCompletion)
                if value == self.requiredCompletion {
                    currentStreak = currentStreak + 1
                    longestStreak = max(longestStreak, currentStreak)
                }
                else {
                    currentStreak = 0
                }
                self.completions[date] = value
            }
        }
        
        self.accentColor = color
    }
    
    // 新建习惯
    init() {
        self.name = "新习惯"
        self.detail = "描述信息"
        self.startDate = Calendar.current.startOfDay(for: Date())
    }
}

//MARK: - Functions
extension Habit {
    func getCompletionPercentage(of date: Date) -> Double {
        let thenCompletion = self.completions[date] ?? 0
        return Double(thenCompletion) / Double(requiredCompletion)
    }
    
    func calculateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        var current = 0
        var longest = 0
        var tillToday = true
        
        for dayIndex in 0..<totalDays {
            let date = calendar.date(byAdding: .day, value: -dayIndex, to: today)!
            let value = self.completions[date] ?? 0
            if value >= self.requiredCompletion {
                current += 1
                longest = max(longest, current)
            }
            else {
                if tillToday {
                    tillToday = false
                    self.currentStreak = current
                }
                current = 0
            }
        }
        
        self.longestStreak = longest
    }
}

extension Habit: Hashable {
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(order)
        hasher.combine(detail)
        hasher.combine(startDate)
        hasher.combine(completions)
    }
}

//MARK: - Migration 数据迁移

struct HabitMigrationVersionedSchema: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Habit.self]
    static let versionIdentifier: Schema.Version = .init(1, 0, 0)
}

struct HabitMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [HabitMigrationVersionedSchema.self]
    static let stages: [MigrationStage] = []
}
