//
//  BandRadialGradient.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/20.
//

import SwiftUI

var bandRadialGradient: RadialGradient {
    RadialGradient(
        colors: [Color(hex: "CBA17B")!.opacity(0.5), .black.opacity(0)],
        center: .center,
        startRadius: 0,
        endRadius: 400
    )
}

#Preview {
    Rectangle()
        .foregroundStyle(bandRadialGradient)
        .ignoresSafeArea()
        .background(.black)
}
