//
//  CustomedStyles.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/29.
//

import SwiftUI

// 渐变描边
var LinearBorderGradient: LinearGradient {
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

// 卡片渐变背景
var LinearCardGradient: LinearGradient {
    LinearGradient(
        gradient:
            Gradient(colors: [
                Color(Color(hex: "002E40")!),
                Color(Color(hex: "001A26")!)
            ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

// 工具栏渐变背景
var LinearToolbarGradient: LinearGradient {
    LinearGradient(
        gradient:
            Gradient(
                colors: [
                    Color(hex: "002639")!,
                    Color(hex: "00141E")!
                ]
            ),
        startPoint: .top,
        endPoint: .bottom)
}

// 渐变描边
var LinearIndicatorGradient: LinearGradient {
    LinearGradient(
            gradient:
                Gradient(colors: [
                    Color.white.opacity(0.15),
                    Color.white.opacity(0.0)
                ]),
           startPoint: .top,
           endPoint: .bottom
    )
}

// 进度条渐变色
var linearAccentColorGradient: LinearGradient {
    LinearGradient(
        gradient: 
            Gradient(
                colors: [.accent, .accent.opacity(0.5)]
            ),
        startPoint: .top,
        endPoint: .bottom
    )
}
