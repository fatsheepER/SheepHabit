//
//  HabitCompletionCaption.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/18.
//

import SwiftUI

struct HabitCompletionCaption: View {
    let completion: Int
    let requirement: Int
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.height / 2)
                .foregroundStyle(.white.opacity(0.15))
            
            Text(String(completion) + " | " + String(requirement))
                .font(.system(size: self.height / 2, weight: .bold))
                .foregroundStyle(.white)
                .opacity(completion >= requirement ? 1 : 0.5)
        }
        .frame(width: self.height * 2, height: self.height)
    }
}

#Preview {
    ZStack {
        Color.indigo
            .ignoresSafeArea()
        
        HabitCompletionCaption(completion: 2, requirement: 3, height: 20)
    }
}
