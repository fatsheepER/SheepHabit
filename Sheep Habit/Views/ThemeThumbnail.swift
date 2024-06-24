//
//  ThemePreview.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/20.
//

import SwiftUI

struct ThemeThumbnail: View {
    let theme: ColorTheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.5)
                .foregroundStyle(theme.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 12.5)
                        .strokeBorder(.white.opacity(0.3), lineWidth: 4)
                }
            
            VStack {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(theme.primary)
                    .frame(height: 25)
                
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(theme.primary)
                    .frame(height: 25)
                    .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(theme.secondary)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(.white.opacity(0.3), lineWidth: 2)
                    }
                    .frame(height: 30)
            }
            .frame(width: 80)
        }
        .frame(width: 100, height: 150)
    }
}

struct ThemePreview: View {
    let theme: ColorTheme
    
    var body: some View {
        HStack {
            ThemeThumbnail(theme: theme)
            
            VStack {
                Text(theme.name)
                    .font(.system(size: 20, weight: .bold))
            }
            
        }
    }
}

#Preview {
    ZStack {
        ThemeThumbnail(theme: ColorTheme(name: "Player", primary: Color(hex: "32A4D9")!, secondary: Color(hex: "002639")!, background: Color(hex: "00141E")!))
    }
    .preferredColorScheme(.dark)
}
