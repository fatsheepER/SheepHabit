//
//  ContentViewFunctions.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/19.
//

import Foundation
import SwiftUI

extension ContentView {
    
    // Today
    // - 获取 LineChart 数据
    func fetchLineChartData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        var newData: [DailyHabitsCompletionPercentage] = []
        for offset in 0..<14 {
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            var completion = 0
            var requirement = 0
            for habit in self.habits {
                if date >= habit.startDate {
                    completion += habit.completions[date] ?? 0
                    requirement += habit.requiredCompletion
                }
            }
            newData.append(DailyHabitsCompletionPercentage(date: date, totalCompletion: completion, totalRequirement: requirement))
        }
        self.lineChartData = newData
    }
    
    // Review
    // - 获取所有有记录的年份 同时计算总使用天数
    func fetchAllRecordedYears() {
        let calendar = Calendar.current
        var furtherestDay = Date.now
        let currentYear = calendar.component(.year, from: .now)
        
        for habit in self.habits {
            if habit.startDate < furtherestDay {
                furtherestDay = habit.startDate
            }
        }
        
        let furtherestYear = calendar.component(.year, from: furtherestDay)
        let yearIndex = currentYear - furtherestYear
        
        totalUsingDays = (calendar.dateComponents([.day], from: furtherestDay, to: .now).day ?? 0) + 1
        
        recordedYears = []
        for index in 0...yearIndex {
            recordedYears.append(index)
        }
    }
    
    // 获取某一年每个月的总共完成数
    func fetchYearlyTotalCompletion() {
        let calendar = Calendar.current
        let thisYear = calendar.dateInterval(of: .year, for: .now)!.start
        
        // 遍历年份的范围
        let startOfYear = calendar.date(byAdding: .year, value: -presentedYearIndex, to: thisYear)!
        let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
        
        yearCompletionRecord = []
        
        // 遍历全年记录
        var values = [Int](repeating: 0, count: 12)
        for habit in self.habits {
            if endOfYear < habit.startDate {
                continue
            }
            
            for (date, value) in habit.completions {
                if date >= startOfYear && date < endOfYear {
                    let monthIndex = calendar.component(.month, from: date)
                    values[monthIndex - 1] += value
                }
            }
        }
        
        // 数组转换
        for index in 0..<12 {
            let value = values[safe: index] ?? 0
            yearCompletionRecord.append(MonthCompletionRecord(monthIndex: index, completionCount: value))
        }
        
        yearCompletionSum = values.reduce(0, +)
    }
    
    // - 获取连续记录
    func fetchStreakData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        // 获取当前连续记录
        var currentStreakCount = 0
        var checkedDate = today
        var flag = true
        
        if self.habits.isEmpty {
            return
        }
        
        while flag {
            for habit in self.habits {
                // 习惯创建时间之前 跳过
                if habit.startDate > checkedDate {
                    
                    // 离开死循环
                    if flag && habit == habits.last {
                        flag = false
                        break
                    }
                    
                    continue
                }
                
                let value = habit.completions[checkedDate] ?? 0
                if value != habit.requiredCompletion {
                    flag = false
                    break
                }
            }
            
            // 达成完美一天
            if flag {
                currentStreakCount += 1
                checkedDate = calendar.date(byAdding: .day, value: -1, to: checkedDate)!
            }
        }
        
        self.currentStreak = currentStreakCount
        
        // 获取最佳记录
        var checkedIndex = 0
        var longestStreakCount = 0
        currentStreakCount = 0
        while checkedIndex < totalUsingDays {
            flag = true
            checkedDate = calendar.date(byAdding: .day, value: -checkedIndex, to: today)!
            for habit in self.habits {
                if habit.startDate > checkedDate {
                    continue
                }
                
                let value = habit.completions[checkedDate] ?? 0
                if value != habit.requiredCompletion {
                    flag = false
                    break
                }
            }
            //
            if flag {
                currentStreakCount += 1
                longestStreakCount = max(longestStreakCount, currentStreakCount)
            }
            else {
                currentStreakCount = 0
            }
            
            checkedIndex += 1
        }
        
        self.longestStreak = longestStreakCount
    }
}
