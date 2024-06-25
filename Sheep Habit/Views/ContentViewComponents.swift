//
//  ContentViewComponents.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/23.
//

import SwiftUI

extension ContentView {
    
    // General
    var background: some View {
        Group {
            if colorManager.selectedTheme.name == "Band On the Escape" {
                bandRadialGradient
                    .ignoresSafeArea()
            }
            else {
                Color(colorManager.selectedTheme.background)
                    .ignoresSafeArea()
            }
        }
    }
    
    // Today tab
//    VStack {
//        Spacer()
//        HStack {
//            Image(systemName: "chevron.down")
//                .font(.system(size: 25, weight: .bold))
//                .foregroundStyle(.white)
//                .frame(maxWidth: .infinity)
////                                                .popoverTip(
////                                                    hideDetailViewButtonTip
////                                                )
//        }
//        .frame(height: 55)
//        .background(.white.opacity(0.001))
//        .onTapGesture {
//            hideDetailViewButtonTip.invalidate(reason: .actionPerformed)
//            withAnimation {
//                isPresentingDetailView = false
//            }
//        }
//        
//    }
//    .ignoresSafeArea()
    
    var detailTabBar: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
            
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.black.opacity(0.15))
            
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            
            HStack {
                
                // Delete
                Button {
                    showToolbarDeleteAlarm = true
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.001))
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                // Archive
                Button {
                    showToolbarArchiveAlarm = true
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.001))
                        Image(systemName: "tray")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                // Edit
                Button {
                    
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.001))
                        Image(systemName: "pencil")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                // Back to homepage
                Button {
                    withAnimation {
                        self.isPresentingDetailView = false
                        presentedHabit = nil
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.001))
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .padding(.horizontal, 0)
        }
        .frame(height: 60)
        .frame(maxWidth: 320)
    }
    
    // Setting tab
    var currentThemeIcon: some View {
        Group {
            if colorManager.selectedTheme.name == "L.A. Girls" {
                AppIconView(size: 100, imageName: "ImageIconLAWoman")
                    .padding(.top, 20)
            }
            else if colorManager.selectedTheme.name == "Dark Dream" {
                AppIconView(size: 100, imageName: "ImageIconBlackDream")
                    .padding(.top, 20)
            }
            else if colorManager.selectedTheme.name == "The Dog, the Sheep and the Pig" {
                AppIconView(size: 100, imageName: "ImageIconAnimals")
                    .padding(.top, 20)
            }
            else if colorManager.selectedTheme.name == "Smoke On the Lake" {
                AppIconView(size: 100, imageName: "ImageIconMomentaryLapse")
                    .padding(.top, 20)
            }
            else if colorManager.selectedTheme.name == "Band On the Escape" {
                AppIconView(size: 100, imageName: "ImageIconBandOnTheRun")
                    .padding(.top, 20)
            }
            else {
                AppIconView(size: 100, imageName: "ImageIconBabyComeBack")
                    .padding(.top, 20)
            }
        }
    }
}
