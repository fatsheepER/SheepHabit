//
//  CustomedPickerView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/23.
//

import SwiftUI

// 星期选择视图

// 主题色选择视图
//struct GridColorPickerView: View {
//    @Binding var selectedColor: Color
//    let columns = Array(repeating: GridItem(.fixed(35), spacing: 8), count: 8)
//    let options: [ColorOption] = [
//        ColorOption(color: Color(hex: "59CAFF")!, description: "Baby Come Back"),
//        ColorOption(color: Color(hex: "A11515")!, description: "In the Court of the Crimson King"),
//        ColorOption(color: Color(hex: "E0BE56")!, description: "Sgt. Pepper's Loney Heart Club Band"),
//        ColorOption(color: Color(hex: "2DC54B")!, description: "Atom Heart Mother"),
//        ColorOption(color: Color(hex: "B639C1")!, description: "Turn Blue"),
//        ColorOption(color: Color(hex: "B20047")!, description: "L.A. Woman"),
//        ColorOption(color: Color(hex: "4351A8")!, description: "Learning to Fly"),
//        ColorOption(color: Color(hex: "0CA388")!, description: "Selling England by the Pound")
//    ]
//    
//    var body: some View {
//        VStack {
//            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
//                ForEach(options) { option in
//                    Circle()
//                        .frame(height: 35)
//                        .foregroundStyle(option.color)
//                        .overlay { // 被选中时的边框
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundStyle(.white)
//                                .opacity(selectedColor == option.color ? 1 : 0)
//                        }
//                        .onTapGesture {
//                            selectedColor = option.color
//                        }
//                }
//            }
//            
//            HStack {
//                Text(options.first(where: { $0.color == selectedColor })?.description ?? "")
//                    .font(.system(size: 10))
//                    .foregroundStyle(.white.opacity(0.6))
//                Spacer()
//            }
//        }
//    }
//}
//
//// 图标选择视图
//struct GridIconPickerView: View {
//    @Binding var selectedIconSystemName: String
//    let columns = Array(repeating: GridItem(.fixed(35), spacing: 8), count: 8)
//    let options: [IconOption] = [
//        IconOption(systemName: "curlybraces"),
//        IconOption(systemName: "book"),
//        IconOption(systemName: "figure.run"),
//        IconOption(systemName: "character.book.closed"),
//        IconOption(systemName: "drop"),
//        IconOption(systemName: "heart"),
//        IconOption(systemName: "figure.pool.swim"),
//        IconOption(systemName: "crown"),
//        IconOption(systemName: "steeringwheel"),
//        IconOption(systemName: "pencil.and.outline"),
//        IconOption(systemName: "alarm"),
//        IconOption(systemName: "face.smiling"),
//        IconOption(systemName: "bed.double"),
//        IconOption(systemName: "eye"),
//        IconOption(systemName: "medal"),
//        IconOption(systemName: "keyboard"),
//        IconOption(systemName: "figure.walk"),
//        IconOption(systemName: "figure.2"),
//        IconOption(systemName: "figure.2.and.child.holdinghands"),
//        IconOption(systemName: "figure.roll.runningpace"),
//        IconOption(systemName: "figure.stairs"),
//        IconOption(systemName: "figure.outdoor.cycle"),
//        IconOption(systemName: "figure.racquetball"),
//        IconOption(systemName: "airplane"),
//        IconOption(systemName: "person.and.background.striped.horizontal"),
//        IconOption(systemName: "sun.max"),
//        IconOption(systemName: "camera"),
//        IconOption(systemName: "exclamationmark.triangle"),
//        IconOption(systemName: "x.squareroot"),
//        IconOption(systemName: "xmark"),
//        IconOption(systemName: "house"),
//        IconOption(systemName: "photo.artframe"),
//        IconOption(systemName: "trophy"),
//        IconOption(systemName: "apple.terminal"),
//        IconOption(systemName: "cup.and.saucer"),
//        IconOption(systemName: "pianokeys"),
//        IconOption(systemName: "guitars"),
//        IconOption(systemName: "music.note"),
//        IconOption(systemName: "mustache"),
//        IconOption(systemName: "newspaper"),
//    ]
//    
//    var body: some View {
//        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
//            ForEach(options) { option in
//                ZStack {
//                    Circle()
//                        .frame(height: 35)
//                        .foregroundStyle(.white.opacity(0.15))
//                        .overlay {
//                            Circle()
//                                .strokeBorder(lineWidth: selectedIconSystemName == option.systemName ? 3 : 0)
//                                .foregroundStyle(.white)
//                        }
//                    
//                    Image(systemName: option.systemName)
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundStyle(.white)
//                }
//                .onTapGesture {
//                    selectedIconSystemName = option.systemName
//                }
//            }
//        }
//    }
//}

// 测试页面
//struct PickerTestView: View {
//    @State var habit: Habit = Habit(testDate: Date(), from: 10)
//    
//    var body: some View {
//        VStack {
//            GridColorPickerView(selectedColor: $habit.accentColor)
//            GridIconPickerView(selectedIconSystemName: $habit.iconSystemName)
//        }
//    }
//}

//#Preview {
//    ZStack {
//        Color(.accentBackground)
//            .ignoresSafeArea()
//        PickerTestView()
//    }
//    
//}
