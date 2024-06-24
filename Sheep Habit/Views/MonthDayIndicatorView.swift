//
//  MonthDayIndicator.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/30.
//

import SwiftUI

struct MonthDayIndicatorView: View {
    let initialDate: Date
    @State private var dates: [Date] = []
    @State private var isLoadingMore = false
    @State private var scrollToEnd = false
    
    var body: some View {
        ZStack {
            background
            
            TabView {
                ForEach(dates, id: \.self) { date in
                    DayBlockView(day: dayOfDate(for: date), isToday: isSameDay(date, initialDate))
                        .id(date)
                        .onAppear {
                            if date == dates.first && isLoadingMore {
                                fetchMoreDates()
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}

// MARK: - Components and functions
extension MonthDayIndicatorView {
    
    // 背景
    private var background: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.accent.opacity(0.15))
    }
    
    // 判断是否是同一天
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    // 获取日期
    private func dayOfDate(for date: Date) -> Int {
        Calendar.current.component(.day, from: date)
    }
    
    // 加载第一批日期
    private func fetchInitialDates() {
        let initialDates = (0..<30).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: initialDate)
        }
        dates.append(contentsOf: initialDates.reversed())
    }
    
    // 加载额外一批日期
    private func fetchMoreDates() {
        if !isLoadingMore { return }
        isLoadingMore = false
        let moreDates = (1...60).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0 - dates.count, to: initialDate)
        }
        dates.insert(contentsOf: moreDates.reversed(), at: 0)
    }
}

struct DayBlockView: View {
    let day: Int
    let isToday: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.accent.opacity(0.45))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(LinearBorderGradient, lineWidth: 1)
                }
                .opacity(isToday ? 1 : 0)
            
            Text("\(day)")
                .foregroundStyle(.white)
                .font(.system(size: 19, weight: .semibold))
        }
        .frame(width: 42, height: 53)
    }
}

#Preview {
    ZStack {
        Color(.accentBackground)
            .ignoresSafeArea()
//        HStack {
//            DayBlockView(day: 27, isToday: false)
//            DayBlockView(day: 28, isToday: false)
//            DayBlockView(day: 29, isToday: false)
//            DayBlockView(day: 30, isToday: true)
//        }
//        .background(RoundedRectangle(cornerRadius: 8)
//            .foregroundStyle(.accent.opacity(0.15)))
        MonthDayIndicatorView(initialDate: Date())
    }
}
