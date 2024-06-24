//
//  DayProgressView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/1.
//

import SwiftUI

struct DayProgressView: View {
    let completed: Int
    let required: Int
    
    var body: some View {
        let percentage: Double = required != 0 ? Double(completed) / Double(required) : 0
        
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                barBackground
                
                barForeground
                    .frame(width: geo.size.width * percentage - 2, height: 18)
                    .padding(.leading, 1)
            }
            .frame(height: 20)
        }
    }
}

// MARK: - Components
extension DayProgressView {
    private var barBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.white.opacity(0.05))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(LinearBorderGradient, lineWidth: 1)
            }
    }
    
    private var barForeground: some View {
        RoundedRectangle(cornerRadius: 9)
            .foregroundStyle(linearAccentColorGradient)
    }
}

#Preview {
    ZStack {
        Color.accentBackground
            .ignoresSafeArea()
        DayProgressView(completed: 2, required: 5)
    }
}
