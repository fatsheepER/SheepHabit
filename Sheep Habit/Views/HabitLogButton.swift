//
//  HabitLogButton.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/25.
//

import SwiftUI

struct HabitLogButton: View {
    let completion: Int
    let requirement: Int
    let day: Int
    let accentColor: Color
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.white.opacity(0.05))
                    .aspectRatio(1.0, contentMode: .fit)
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(self.accentColor)
                    .opacity(Double(self.completion) / Double(self.requirement))
                    .aspectRatio(1.0, contentMode: .fit)
                
                Group {
                    if self.completion >= self.requirement {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .frame(height: 13)
                    }
                    else {
                        Text(String(self.day))
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .frame(height: 13)
                    }
                }
                
            }
            
            ZStack {
                Capsule()
                    .aspectRatio(2.0, contentMode: .fit)
                    .foregroundStyle(.white.opacity(0.15))
                
                Text(String(self.completion) + "|" + String(self.requirement))
                    .font(.system(size: 7, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 2.5)
        }
    }
}

#Preview {
    ZStack {
        Color.accentBackground
            .ignoresSafeArea()
        
        HabitLogButton(completion: 1, requirement: 3, day: 14, accentColor: .blue)
    }
    .preferredColorScheme(.dark)
}
