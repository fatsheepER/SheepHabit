//
//  HabitManager.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/20.
//

import SwiftUI
import SwiftData

class HabitManager: ObservedObject {
    private var modelContext: ModelContext
    @Published var habits: [Habit] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.habits = modelContext.fetch(FetchRequest<Habit>())
    }
    
    func fetchHabits() {
        let fetchRequest = FetchRequest<Habit>()
    }
}
