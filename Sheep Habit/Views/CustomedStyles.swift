//
//  CustomedStyles.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/29.
//

import SwiftUI

// 渐变描边
var linearBorderGradient: LinearGradient {
    LinearGradient(
            gradient:
                Gradient(colors: [
                    Color.white.opacity(0.3),
                    Color.white.opacity(0.05)
                ]),
           startPoint: .top,
           endPoint: .bottom
    )
}

var bandRadialGradient: RadialGradient {
    RadialGradient(
        colors: [Color(hex: "CBA17B")!.opacity(0.5), .black.opacity(0)],
        center: .center,
        startRadius: 0,
        endRadius: 400
    )
}
