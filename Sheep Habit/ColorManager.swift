//
//  ColorManager.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/19.
//

import Foundation
import SwiftUI

struct ColorTheme: Codable {
    let name: String
    let primary: Color
    let secondary: Color
    let background: Color
    
    enum CodingKeys: CodingKey {
        case name, primary, secondary, background
    }
    
    init(name: String, primary: Color, secondary: Color, background: Color) {
        self.name = name
        self.primary = primary
        self.secondary = secondary
        self.background = background
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.primary = Color(hex: try container.decode(String.self, forKey: .primary))!
        self.secondary = Color(hex: try container.decode(String.self, forKey: .secondary))!
        self.background = Color(hex: try container.decode(String.self, forKey: .background))!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(self.primary.toHex()!, forKey: .primary)
        try container.encode(self.secondary.toHex()!, forKey: .secondary)
        try container.encode(self.background.toHex()!, forKey: .background)
    }
}

class ColorManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedThemeData: Data?
    
    @Published var selectedTheme: ColorTheme {
        didSet {
            saveTheme(selectedTheme)
        }
    }
    
    @Published var allShowInThemeAccent: Bool = false
    
    let themes: [ColorTheme] = [
        ColorTheme(name: "Player", primary: Color(hex: "32A4D9")!, secondary: Color(hex: "002639")!, background: Color(hex: "00141E")!),
        ColorTheme(name: "L.A. Girls", primary: Color(hex: "FAE74D")!, secondary: Color(hex: "560B13")!, background: Color(hex: "2C0509")!),
        ColorTheme(name: "Dark Dream", primary: Color(hex: "ADC3A5")!, secondary: Color(hex: "2D4422")!, background: Color(hex: "1C2617")!),
        ColorTheme(name: "The Dog, the Sheep and the Pig", primary: Color(hex: "B67C48")!, secondary: Color(hex: "4D1F1F")!, background: Color(hex: "2D1111")!),
        ColorTheme(name: "Literally Deep Purple", primary: Color(hex: "787DE3")!, secondary: Color(hex: "2D2F60")!, background: Color(hex: "14162D")!),
        ColorTheme(name: "Band On the Escape", primary: Color(hex: "CBA17B")!, secondary: Color(hex: "937458")!, background: Color(hex: "000000")!),
    ]
    
    init() {
        // 默认主题
        self.selectedTheme = themes[0]
        
        if let selectedThemeData = selectedThemeData, let theme = try? JSONDecoder().decode(ColorTheme.self, from: selectedThemeData) {
            self.selectedTheme = theme
        }
    }
    
    private func saveTheme(_ theme: ColorTheme) {
        if let data = try? JSONEncoder().encode(theme) {
            selectedThemeData = data
        }
    }
}

extension ColorTheme: Hashable {
    static func == (lhs: ColorTheme, rhs: ColorTheme) -> Bool {
        lhs.name == rhs.name && lhs.primary == rhs.primary
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(primary)
        hasher.combine(secondary)
        hasher.combine(background)
    }
}
