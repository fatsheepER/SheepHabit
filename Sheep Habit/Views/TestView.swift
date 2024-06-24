//
//  HabitTestView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/21.
//

import SwiftUI



struct TestView: View {
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let x = (sin(timeline.date.timeIntervalSince1970) + 1) / 2

            MeshGradient(width: 3, height: 3, points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [Float(x), 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ], colors: [
                .red, .red, .red,
                .blue, .orange, .blue,
                .red, .red, .red
            ])
            
            Text("Gradient")
            
        }
        
    }
}

#Preview {
    VStack {
        TestView()
    }
}
