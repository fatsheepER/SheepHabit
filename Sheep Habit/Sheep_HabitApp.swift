//
//  Sheep_HabitApp.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct Sheep_HabitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        // return ModelContainer
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var colorManager = ColorManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    Tips.showAllTipsForTesting() // 测试用
                    
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                .environmentObject(colorManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
