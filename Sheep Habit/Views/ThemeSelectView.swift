//
//  ThemeSelectView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/19.
//

import SwiftUI

struct ThemeSelectView: View {
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(colorManager.themes, id:\.self) { theme in
                    let isSelected = colorManager.selectedTheme == theme
                    
                    HStack {
                        ThemeThumbnail(theme: theme)
                            .scaleEffect(0.5)
                            .frame(width: 50, height: 75)
                        
                        VStack {
                            Text(theme.name)
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                withAnimation {
                                    colorManager.selectedTheme = theme
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(isSelected ? .white.opacity(0.5) : colorManager.selectedTheme.primary)
                                        .frame(width: 80, height: 40)
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                    else {
                                        Text("启用")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white.opacity(0.1))
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
        }
        .navigationTitle("主题")
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    @Previewable @StateObject var colorManger = ColorManager()
    
    NavigationStack {
        ZStack {
//            colorManger.selectedTheme.background
//                .ignoresSafeArea()
            
            ThemeSelectView()
        }
    }
        .environmentObject(colorManger)
        .preferredColorScheme(.dark)
}
