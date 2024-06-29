//
//  SymbolPickerView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/27.
//

import SwiftUI

struct SymbolOption: Identifiable, Equatable {
    let id = UUID()
    let systemName: String
    
    static func ==(lhs: SymbolOption, rhs: SymbolOption) -> Bool {
        return lhs.systemName == rhs.systemName
    }
}

struct SymbolPicker: View {
    let defaultSymbols = [
        SymbolOption(systemName: "curlybraces"),
        SymbolOption(systemName: "book"),
        SymbolOption(systemName: "figure.run"),
        SymbolOption(systemName: "character.book.closed"),
        SymbolOption(systemName: "drop"),
        SymbolOption(systemName: "heart"),
        SymbolOption(systemName: "figure.pool.swim"),
        SymbolOption(systemName: "crown"),
        SymbolOption(systemName: "steeringwheel"),
        SymbolOption(systemName: "pencil.and.outline"),
        SymbolOption(systemName: "alarm"),
        SymbolOption(systemName: "face.smiling"),
        SymbolOption(systemName: "bed.double"),
        SymbolOption(systemName: "eye"),
        SymbolOption(systemName: "medal"),
        SymbolOption(systemName: "keyboard"),
        SymbolOption(systemName: "figure.walk"),
        SymbolOption(systemName: "figure.2"),
        SymbolOption(systemName: "figure.2.and.child.holdinghands"),
        SymbolOption(systemName: "figure.roll.runningpace"),
        SymbolOption(systemName: "figure.stairs"),
        SymbolOption(systemName: "figure.outdoor.cycle"),
        SymbolOption(systemName: "figure.racquetball"),
        SymbolOption(systemName: "airplane"),
        SymbolOption(systemName: "person.and.background.striped.horizontal"),
        SymbolOption(systemName: "sun.max"),
        SymbolOption(systemName: "camera"),
        SymbolOption(systemName: "exclamationmark.triangle"),
        SymbolOption(systemName: "x.squareroot"),
        SymbolOption(systemName: "xmark"),
        SymbolOption(systemName: "house"),
        SymbolOption(systemName: "trophy"),
        SymbolOption(systemName: "apple.terminal"),
        SymbolOption(systemName: "cup.and.saucer"),
        SymbolOption(systemName: "pianokeys"),
        SymbolOption(systemName: "guitars"),
        SymbolOption(systemName: "music.note"),
        SymbolOption(systemName: "mustache"),
        SymbolOption(systemName: "newspaper"),
    ]
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 25, maximum: 35)), count: 8)
    
    @Binding var selectedSymbolSystemName: String
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(defaultSymbols) { option in
                    ZStack {
                        Circle()
                            .foregroundStyle(.white.opacity(0.2))
                        
                        Image(systemName: option.systemName)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        if selectedSymbolSystemName == option.systemName {
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            isEditing = false
                            selectedSymbolSystemName = option.systemName
                        }
                    }
                }
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white.opacity(0.2))
                    
                    if isEditing {
                        Image(systemName: selectedSymbolSystemName)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                    }
                    else {
                        Image(systemName: "questionmark")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isEditing = true
                        selectedSymbolSystemName = "questionmark.circle.fill"
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0.2))
                
                TextField("输入 SF Symbol 名称", text: $selectedSymbolSystemName)
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
//        Color.black
//            .ignoresSafeArea()
//        
//        SymbolPicker()
//    }
//}
