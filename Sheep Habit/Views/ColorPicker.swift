//
//  ColorPicker.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/27.
//

import SwiftUI

struct ColorOption: Identifiable {
    let id = UUID()
    let color: Color
    let description: String
}

struct ColorPicker: View {
    let defaultColors = [
        ColorOption(color: Color(hex: "59CAFF")!, description: "Baby Come Back"),
        ColorOption(color: Color(hex: "A11515")!, description: "In the Court of the Crimson King"),
        ColorOption(color: Color(hex: "E0BE56")!, description: "Sgt. Pepper's Loney Heart Club Band"),
        ColorOption(color: Color(hex: "2DC54B")!, description: "Atom Heart Mother"),
        ColorOption(color: Color(hex: "B639C1")!, description: "Turn Blue"),
        ColorOption(color: Color(hex: "B20047")!, description: "L.A. Woman"),
        ColorOption(color: Color(hex: "4351A8")!, description: "Learning to Fly"),
        ColorOption(color: Color(hex: "0CA388")!, description: "Selling England by the Pound")
    ]
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 25, maximum: 35)), count: 8)
    
    @Binding var selectedColorHex: String
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(defaultColors) { option in
                    ZStack {
                        Circle()
                            .foregroundStyle(option.color)
                        
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                        
                        if selectedColorHex == option.color.toHex()! {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            isEditing = false
                            selectedColorHex = option.color.toHex()!
                        }
                    }
                }
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white.opacity(0.2))
                    
                    if isEditing {
                        if let customedColor = Color(hex: selectedColorHex) {
                            Circle()
                                .foregroundStyle(customedColor)
                        }
                        else {
                            Circle()
                                .foregroundStyle(.gray)
                        }
                        
                        Circle()
                            .strokeBorder(Color.purple.gradient, lineWidth: 2)
                    }
                    else {
                        Circle()
                            .foregroundStyle(.gray)
                        
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isEditing = true
                        selectedColorHex = "FFFFFF"
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0.2))
                
                TextField("输入 SF Symbol 名称", text: $selectedColorHex)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
            }
                .frame(height: 40)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .opacity(isEditing ? 1 : 0)
        }
    }
}

//#Preview {
//    ZStack {
//        Color(.black)
//            .ignoresSafeArea()
//        
//        ColorPicker()
//    }
//}
