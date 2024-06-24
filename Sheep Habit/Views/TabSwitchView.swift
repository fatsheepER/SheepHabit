//
//  TabSwitchView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/1.
//

import SwiftUI

enum Tab: Int {
    case today = 0
    case reflect = 1
    case setting = 2
}

// 页面切换器
struct TabSwitchView: View {
    @Binding var presentedTab: Tab
    @EnvironmentObject var colorManager: ColorManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let tabIndex = presentedTab.rawValue
                
                background
                
                indicator
                    .frame(width: 110, height: 70)
                    .offset(x: CGFloat((tabIndex - 1)) * 70)
                    .animation(.spring, value: tabIndex)
                
                HStack(spacing: 0) {
                    
                    Label(presentedTab == .today ? "首页" : "", systemImage: "house")
                        .frame(width: presentedTab == .today ? 120 : 70)
                        .background(.white.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                presentedTab = .today
                            }
                        }
                    
                    Label(presentedTab == .reflect ? "回顾" : "", systemImage: "clock.arrow.circlepath")
                        .frame(width: presentedTab == .reflect ? 120 : 70)
                        .background(.white.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                presentedTab = .reflect
                            }
                        }
                    
                    Label(presentedTab == .setting ? "设置" : "", systemImage: "gear")
                        .frame(width: presentedTab == .setting ? 120 : 70)
                        .background(.white.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                presentedTab = .setting
                            }
                        }
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .animation(.interactiveSpring, value: presentedTab)
                
            }
            .frame(width: 260, height: 80)
            .sensoryFeedback(.selection, trigger: presentedTab)
        }
    }
}

// MARK: - Components
extension TabSwitchView {
    private var background: some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundStyle(colorManager.selectedTheme.secondary)
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            }
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: 35)
            .foregroundStyle(.white.opacity(0.1))
    }
}

//#Preview {
//    ZStack {
//        Color.accentBackground
//            .ignoresSafeArea()
//        TabSwitchView()
//    }
//}
