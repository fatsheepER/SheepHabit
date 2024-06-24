//
//  ContentView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import SwiftUI
import SwiftData

extension Habit {
    static func notArchivedPredicate() -> Predicate<Habit> {
        return #Predicate<Habit> { habit in
            habit.isArchieved == false
        }
    }
    
    static func archivedPredicate() -> Predicate<Habit> {
        return #Predicate<Habit> { habit in
            habit.isArchieved == true
        }
    }
}

struct ContentView: View {
    
    // data
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var colorManager: ColorManager
    
    @Query(filter: Habit.notArchivedPredicate(),
           sort: \Habit.startDate,
           animation: .smooth) var habits: [Habit]
    @Query(filter: Habit.archivedPredicate(),
           sort: \Habit.startDate,
           animation: .smooth) var archived: [Habit]
    
    // tabs
    @State var isPresentingTabSwitch = true
    @State var presentedTab: Tab = .today
    
    // add new habit
    @State var isPresentingAddNewHabit = false
    
    // habit detail
    @State var isPresentingDetailView = false
    @State var presentedHabit: Habit?
    @State var isPresentingDeleteAlert = false
    let hideDetailViewButtonTip = HideDetailViewButton()
    
    // Review
    // - 总使用天数
    @State var totalUsingDays: Int = 0
    // - Streak
    @State var currentStreak: Int = 0
    @State var longestStreak: Int = 0
    // - Year Completion
    // - - 当前显示年份
    @State var presentedYearIndex: Int = 0
    // - - 是否展开
    @State var isExpandingYearBlock: Bool = false
    // - - 有记录的年份
    @State var recordedYears: [Int] = []
    // - - 当前年份的统计
    @State var yearCompletionRecord: [MonthCompletionRecord] = []
    // - - 当前年份总计
    @State var yearCompletionSum: Int = 0
    
    // Setting
    // - Change App Icon
    @State var isPresentingSettingDetailView = false
    
    @State var lineChartData: [DailyHabitsCompletionPercentage] = []
    
    var body: some View {
        
        ZStack {
            Color(colorManager.selectedTheme.background)
                .ignoresSafeArea()
            
            Group {
                switch presentedTab {
                case .today:
                    todayTab
                    
                case .reflect:
                    reflectTab
                    
                case .setting:
                    settingTab
                }
            }
            
            VStack {
                Spacer()
                if isPresentingTabSwitch {
                    VStack {
                        TabSwitchView(presentedTab: $presentedTab)
                            .frame(width: 240, height: 80)
                            .padding(.top, 50)
                    }
                    .frame(height: 150)
                    .transition(.move(edge: .bottom))
                    .animation(.smooth(duration: 0.1), value: isPresentingTabSwitch)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .preferredColorScheme(.dark)
    }
    
    private var totalRequiredCompletion: Int {
        habits.reduce(0) { $0 + $1.requiredCompletion }
    }
    
    private var totalTodayCompletion: Int {
        habits.reduce(0) { $0 + $1.todayCompletion }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

// MARK: - Functions
extension ContentView {
    
    
    
    
    
    
    
    
}

// MARK: - Tabs
extension ContentView {
    
    // 今日页
    var todayTab: some View {
        NavigationStack {
            ZStack {
                
                // 背景
                background
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if !habits.isEmpty {
                            HabitLineChart(data: lineChartData, accentColor: colorManager.selectedTheme.primary)
                                .onAppear {
                                    fetchLineChartData()
                                }
                                .onChange(of: habits.hashValue) {
                                    fetchLineChartData()
                                }
                                .padding(.vertical)
                        }
                        
                        ForEach(habits) { habit in
                            
                            Button {
                                withAnimation {
                                    presentedHabit = habit
                                    isPresentingDetailView = true
                                }
                            } label: {
                                HabitView(habit: habit)
                                    .frame(width: UIScreen.main.bounds.width - 24)
                                    .padding(.horizontal, 12)
                                    .contextMenu {
                                        Button("归档", systemImage: "archivebox") {
                                            habit.isArchieved = true
                                        }
                                        
                                        Button(role: .destructive) {
                                            modelContext.delete(habit)
                                        } label: {
                                            Label("删除", systemImage: "trash")
                                        }
                                    }
                            }
                            .padding(.bottom, 20)
                            .fullScreenCover(isPresented: $isPresentingDetailView) {
                                ZStack {
                                    Rectangle()
                                        .fill(Material.ultraThin)
                                        .ignoresSafeArea()
                                    
                                    if let _habit = presentedHabit {
                                        ScrollView(.vertical, showsIndicators: false) {
                                            HabitDetailView(habit: _habit)
                                                .presentationBackground(.clear)
                                                .padding(.horizontal, 5)
                                                .padding(.bottom, 60)
                                        }
                                    }
                                    
                                    // 工具栏
                                    VStack {
                                        Spacer()
                                        
                                        detailTabBar
                                            .padding(.bottom, 20)
                                            .alert(isPresented: $isPresentingDeleteAlert) {
                                                Alert(
                                                    title: Text("确定删除这个习惯吗？"),
                                                    message: Text("此操作无法撤销。"),
                                                    primaryButton: .destructive(Text("删除")) {
                                                        isPresentingDetailView = false
                                                        modelContext.delete(presentedHabit!)
                                                    },
                                                    secondaryButton: .cancel()
                                                )
                                            }
                                    }
                                    .ignoresSafeArea()
                                }
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 160)
                            .opacity(0)
                    }
                }
                .navigationTitle("Sheep Habit")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button {
                                let testHabit = Habit(testDate: Date(), from: 400, color: colorManager.selectedTheme.primary)
                                modelContext.insert(testHabit)
                            } label: {
                                Image(systemName: "hammer.fill")
                            }
                            
                            Button {
                                withAnimation {
                                    isPresentingAddNewHabit.toggle()
                                }
                            } label: {
                                Image(systemName:"plus.circle.fill")
                            }
                        }
                        .foregroundStyle(.white)
                    }
                }
                
                if habits.isEmpty {
                    ContentUnavailableView("没有正在追踪的习惯", systemImage: "tray", description: Text("点击右上角加号，立即开始建立新习惯。"))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .fullScreenCover(isPresented: $isPresentingAddNewHabit, content: {
            AddNewHabitView(stateIndex: 0, isPresented: $isPresentingAddNewHabit)
        })
        .sensoryFeedback(.success, trigger: isPresentingAddNewHabit)
        .sensoryFeedback(.success, trigger: isPresentingDetailView)
    }
    
    // 回顾页
    var reflectTab: some View {
        NavigationStack {
            ZStack {
                background
                
                ScrollView(.vertical, showsIndicators: false) {
                    // Review Blocks
                    VStack(spacing: 10) {
                        let standardWidth = UIScreen.main.bounds.width / 2 - 25
                        HStack(spacing: 10) {
                            // 已经使用 x 天
                            TotalUsageTimeBlock(days: totalUsingDays)
                                .frame(width: standardWidth, height: standardWidth)
                            
                            VStack(spacing: 10) {
                                // 当前连续记录
                                StreakBlock(type: .currentStreak, days: self.currentStreak, accentColor: colorManager.selectedTheme.primary)
                                    .frame(height: (standardWidth - 10) / 2)
                                
                                // 最长连续记录
                                StreakBlock(type: .longestStreak, days:self.longestStreak, accentColor: colorManager.selectedTheme.primary)
                                    .frame(height: (standardWidth - 10) / 2)
                            }
                        }
                        
                        // Yearly Review
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.white.opacity(0.05))
                            
                            VStack {
                                
                                // 常驻部分
                                HStack(alignment: .bottom) {
                                    
                                    // 今年完成 x 次
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                        // x 次
                                        HStack(alignment: .bottom, spacing: 3) {
                                            Text("\(yearCompletionSum)")
                                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                            
                                            Text("次")
                                                .font(.system(size: 14, weight: .medium))
                                                .padding(.bottom, 5)
                                        }
                                        .foregroundStyle(.white)
                                        .frame(height: 30)
                                        
                                        Text(self.presentedYearIndex == 0 ? "今年" : String(2024 - self.presentedYearIndex) + "年")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.5))
                                        
                                        Text("完成习惯")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                    
                                    // 图表
                                    YearBlockChart(records: yearCompletionRecord, accentColor: .white)
                                        .onChange(of: presentedYearIndex) {
                                            fetchYearlyTotalCompletion()
                                        }
                                        .sensoryFeedback(.success, trigger: presentedYearIndex)
                            
                                }
                                .frame(height: 70)
                                
                                // 拓展部分
                                if isExpandingYearBlock {
                                    HStack(spacing: 10) {
                                        Text("全部时间")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(.white.opacity(0.5))
                                        
                                        let year = Calendar.current.component(.year, from: .now)
                                        
                                        ForEach(recordedYears, id: \.self) { index in
                                            let isSelected: Bool = (index == presentedYearIndex)
                                            Button {
                                                presentedYearIndex = index
                                            } label: {
                                                YearSelectButton(year: year - index, isSelected: isSelected)
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 6)
                                    .animation(.easeInOut(duration: 0.2), value: isExpandingYearBlock)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(LinearBorderGradient, lineWidth: 1)
                        }
                        .frame(height: self.isExpandingYearBlock ? 140 : 105)
                        .onTapGesture {
                            withAnimation {
                                self.isExpandingYearBlock.toggle()
                            }
                        }
                        .sensoryFeedback(.success, trigger: isExpandingYearBlock)
                    }
                    .padding(20)
                    
                    // Archieved habits
                    HStack {
                        Text("已归档")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    
                    ForEach(archived) { habit in
                        
                        Button {
                            withAnimation {
                                presentedHabit = habit
                            }
                        } label: {
                            HabitView(habit: habit)
                                .frame(width: UIScreen.main.bounds.width - 24)
                                .padding(.horizontal, 12)
                        }
                        .padding(.bottom, 20)
                        .contextMenu {
                            Button("取消归档", systemImage: "archivebox") {
                                habit.isArchieved = false
                            }
                            
                            Button(role: .destructive) {
                                modelContext.delete(habit)
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                    }
                }
                .onAppear() {
                    fetchAllRecordedYears()
                    fetchYearlyTotalCompletion()
                    fetchStreakData()
                }
            }
            .navigationTitle("回顾")
        }
        .scrollContentBackground(.hidden)
    }
    
    // 设置页
    var settingTab: some View {
        NavigationStack {
            ZStack {
                background
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // 主题图标展示
                    currentThemeIcon
                    
                    
                    Text("Sheep Habit")
                        .font(.system(size: 30, weight: .bold))
                    
                    Text("Proudly made by fatsheepER")
                        .font(.system(size: 12, weight: .thin))
                        .padding(.bottom, 18)
                    
                    HStack() {
                        NavigationLink {
                            Text("Feedback")
                        } label: {
                            LargeNavigationButton(title: "反馈与建议", systemName: "exclamationmark.bubble")
                        }

                        NavigationLink {
                            Text("Roadmap")
                        } label: {
                            LargeNavigationButton(title: "更新计划", systemName: "flag.pattern.checkered")
                        }
                        
                        NavigationLink {
                            Text("Notice")
                        } label: {
                            LargeNavigationButton(title: "公告", systemName: "horn")
                        }
                        
                        NavigationLink {
                            Text("Praise")
                        } label: {
                            LargeNavigationButton(title: "表达喜爱", systemName: "hand.thumbsup")
                        }
                    }
                    .frame(maxWidth: 390)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 28)
                    
                    HStack {
                        Text("设置项")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    
                    VStack {
                        NavigationLink {
                            ThemeSelectView()
                                .onAppear {
                                    withAnimation {
                                        isPresentingTabSwitch = false
                                    }
                                }
                                .onDisappear {
                                    withAnimation {
                                        isPresentingTabSwitch = true
                                    }
                                }
                        } label: {
                            NavigationButton(title: "主题", iconSystemName: "paintpalette", height: 48, cornerRadius: 10, fontSize: 15)
                        }
                        
                        NavigationLink {
                            Text("Habit Card Appearance")
                        } label: {
                            NavigationButton(title: "习惯卡片外观", iconSystemName: "append.page", height: 48, cornerRadius: 10, fontSize: 15)
                        }
                        
                        NavigationLink {
                            AppIconPickerView()
                                .onAppear {
                                    withAnimation {
                                        isPresentingTabSwitch = false
                                    }
                                }
                                .onDisappear {
                                    withAnimation {
                                        isPresentingTabSwitch = true
                                    }
                                }
                        } label: {
                            NavigationButton(title: "图标", iconSystemName: "app", height: 48, cornerRadius: 10, fontSize: 15)
                        }
                        
                        NavigationLink {
                            Text("iCloud Sync")
                        } label: {
                            NavigationButton(title: "iCloud 同步", iconSystemName: "icloud", height: 48, cornerRadius: 10, fontSize: 15)
                        }
                        
                        NavigationLink {
                            Text("More")
                        } label: {
                            NavigationButton(title: "更多", iconSystemName: "ellipsis", height: 48, cornerRadius: 10, fontSize: 15)
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 180)
                        .opacity(0)
                }
            }
            .navigationTitle("设置")
        }
        .scrollContentBackground(.hidden)
    }
}

struct LargeNavigationButton: View {
    let title: String
    let systemName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(backgroundGradient)
            
            VStack(spacing: 7) {
                Image(systemName: self.systemName)
                    .font(.system(size: 35, weight: .medium))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(.white)
            
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.white.opacity(0.3), lineWidth: 1)
        }
        .frame(height: 100)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(colors: [.white.opacity(0.2), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    @Previewable @StateObject var colorManager = ColorManager()
    
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
        .environmentObject(colorManager)
        
}
