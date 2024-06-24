//
//  IconView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/14.
//

import SwiftUI

struct AppIconView: View {
    let size: CGFloat
    let imageName: String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
            
            RoundedRectangle(cornerRadius: size / 4, style: .circular)
                .strokeBorder(.secondary, lineWidth: 2)
                .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: size / 4, style: .circular))
        .frame(width: size, height: size)
    }
}

struct AppIconOption: Identifiable {
    let id: String = UUID().uuidString
    let iconName: String
    let description: String
}

let appIcons: [AppIconOption] = [
    AppIconOption(iconName: "IconBabyComeBack", description: "Baby Get Back"),
    AppIconOption(iconName: "IconBandOnTheRun", description: "1985"),
    AppIconOption(iconName: "IconTheWall", description: "Go to the Show"),
    AppIconOption(iconName: "IconBlackDream", description: "The Higher Being"),
    AppIconOption(iconName: "IconAnimals", description: "Pigs Might Fly"),
    AppIconOption(iconName: "IconLAWoman", description: "I'm A Changeling"),
    AppIconOption(iconName: "IconMomentaryLapse", description: "Smoke On the Lake"),
    AppIconOption(iconName: "IconSellingEngland", description: "Old Father Thames"),
    AppIconOption(iconName: "IconSgtPepper", description: "Lucy In the Sky"),
    
]

struct AppIconPickerView: View {
    
    @AppStorage("AppIconName") var appIconName: String?
    
    let columns = Array(repeating: GridItem(.fixed(80), spacing: 5), count: 3)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(appIcons) { option in
                    Button {
                        changeAppIcon(to: option.iconName)
                    } label: {
                        HStack {
                            AppIconView(size: 60, imageName: "Image" + option.iconName)
                                .padding(.trailing, 10)
                            Text(option.description)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            if option.iconName == appIconName || (appIconName == nil && option.iconName == "IconBabyComeBack") {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                }
            }
            .navigationTitle("图标")
        }
    }
    
    // 切换图标
    private func changeAppIcon(to iconName: String) {
        if iconName == "IconBabyComeBack" {
            UIApplication.shared.setAlternateIconName(nil)
            appIconName = nil
        }
        else {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print("Error setting alternate icon \(error.localizedDescription)")
                }
            }
            appIconName = iconName
        }
    }
}
