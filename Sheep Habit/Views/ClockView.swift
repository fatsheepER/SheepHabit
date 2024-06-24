//
//  ClockView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/18.
//

import SwiftUI

struct ClockView: View {
    var tickCount = 60  // 刻度的总数，可以调整为12以显示小时刻度

    var body: some View {
        ZStack {
            
            ForEach(0..<tickCount, id: \.self) { tick in
                VStack {
                    Rectangle()
                        .frame(width: tick % 5 == 0 ? 2 : 1, height: 10)  // 每5个刻度加粗显示
                    Spacer()
                }
                .rotationEffect(Angle.degrees(Double(tick) / Double(tickCount) * 360))
            }
        }
    }
}

#Preview {
    ClockView()
        .frame(width: 150, height: 150)
}
