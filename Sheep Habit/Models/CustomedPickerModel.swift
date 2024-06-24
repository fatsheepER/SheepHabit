//
//  CustomedPickerModel.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/23.
//

import SwiftUI

struct ColorOption: Identifiable {
    let id = UUID()
    let color: Color
    let description: String
}

struct IconOption: Identifiable {
    let id = UUID()
    let systemName: String
}

