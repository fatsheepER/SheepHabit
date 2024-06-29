//
//  AddNewHabitView.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/5/29.
//

import SwiftUI

/*
 0. Welcome // Only for first time
 1. Name
 2. Detail
 3. Required Completion
 4. Color and icon
 5. Finish // Back or continue
 6. Reminder
 7. Start Date
 */

/*
 Todo List
 1. (done) TextField focus
 2. (done) No nil-value detection
 3. Leave the buttons under keyboard
 4. (done) Hapitic feedback
 */

struct AddNewHabitView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var colorManager: ColorManager
    @Binding var isPresented: Bool
    
    @State var state: Int = 0;
    @State var name: String = ""
    @State var detail: String = ""
    @State var requiredCompletion: Int = 1
    @State var iconSystemName: String = "curlybraces"
    @State var accentColorHex: String = "59CAFF"
    
    @FocusState var focusOnName: Bool
    @FocusState var focusOnDetail: Bool
    
    
    
    var body: some View {
        ZStack {
            Color(colorManager.selectedTheme.background)
                .ignoresSafeArea()
            
            VStack {
                switch state {
                case 0:
                    welcomeSection
                        .transition(.move(edge: .bottom))
                    
                case 1:
                    nameSection
                        .transition(.move(edge: .bottom))
                    
                case 2:
                    detailSection
                        .transition(.move(edge: .bottom))
                    
                case 3:
                    requiredCompletionView
                        .transition(.move(edge: .bottom))
                    
                case 4:
                    colorAndIconSection
                        .transition(.move(edge: .bottom))
                    
                case 5:
                    finishSection
                        .transition(.move(edge: .bottom))
                    
                default:
                    Text("There's no way out of here.")
                        .transition(.move(edge: .bottom))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    if state == 1 {
                        exitButton
                            .animation(.smooth, value: state)
                            .frame(width: 100)
                    }
                    else if state > 0 {
                        backButton
                            .animation(.smooth, value: state)
                            .frame(width: 100)
                    }
                    nextButton
                        .animation(.bouncy, value: state)
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: state)
        
    }
}

//MARK: - Inits
extension AddNewHabitView {
    
    init(stateIndex: Int, isPresented: Binding<Bool>) {
        self.state = stateIndex
        self._isPresented = isPresented
    }
}

//MARK: - Sections
extension AddNewHabitView {
    
    // 欢迎界面
    private var welcomeSection: some View {
        VStack {
            Text("👏欢迎使用\nSheep Habit\n")
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold))
            
            Text("首先，让我们制定你的第一个习惯")
                .font(.system(size: 20, weight: .bold))
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
    }
    
    // 输入名称
    private var nameSection: some View {
        VStack {
            Text("🤔首先，为你的习惯取个名字：")
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold))
                .padding(.horizontal)
            
            ZStack {
                textFieldBackground
                TextField("习惯名称", text: $name)
                .font(.system(size: 20))
                .padding(.horizontal)
                .onSubmit {
                    pressNextButton()
                }
                .submitLabel(.done)
                .focused($focusOnName)
            }
            .frame(height: 70)
            .padding()
        }
        .frame(maxHeight: .infinity)
    }
    
    // 输入详情
    private var detailSection: some View {
        VStack {
            Text("🧐这个习惯为什么重要？它的好处是什么：")
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold))
                .padding(.horizontal)
            
            ZStack {
                textFieldBackground
                TextField("为什么重要", text: $detail)
                .font(.system(size: 20))
                .padding(.horizontal)
                .onSubmit {
                    pressNextButton()
                }
                .submitLabel(.done)
                .focused($focusOnDetail)
            }
            .frame(height: 70)
            .padding()
        }
        .frame(maxHeight: .infinity)
    }
    
    // 选择每日完成次数
    private var requiredCompletionView: some View {
        VStack {
            Text("🔢这个习惯一天需要完成几次：")
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold))
                .padding(.horizontal)
            
            Text("\(requiredCompletion)")
                .font(.system(size: 50, weight: .bold))
                .padding(.vertical)
            
            Stepper("", value: $requiredCompletion, in: 1...100)
                .labelsHidden()
                .font(.system(size: 30))
        }
        .frame(maxHeight: .infinity)
        .sensoryFeedback(.increase, trigger: requiredCompletion)
    }
    
    // 选择 Color 和 Icon
    private var colorAndIconSection: some View {
        VStack {
            ZStack() {
                Image(systemName: iconSystemName)
                    .font(.system(size: 50, weight: .medium))
                
                if let accentColor = Color(hex: accentColorHex) {
                    Circle()
                        .strokeBorder(lineWidth: 4)
                        .frame(height: 130)
                        .foregroundStyle(accentColor)
                }
                else {
                    Circle()
                        .strokeBorder(lineWidth: 4)
                        .frame(height: 130)
                        .foregroundStyle(.gray)
                }
                
            }
            .frame(width: 130, height: 130)
            .padding(.bottom, 50)
            .padding(.top, 80)
            
            Text("🎨选择图标和颜色：")
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold))
            
            ScrollView(.vertical, showsIndicators: false) {
                ColorPicker(selectedColorHex: $accentColorHex)
                
                SymbolPicker(selectedSymbolSystemName: $iconSystemName)
            }
            .padding(.bottom, 80)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    // 结束（或者继续）
    private var finishSection: some View {
        VStack {
            Text("🎉你已经完成了创建过程，一切尽在掌握")
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold))
                .padding(.horizontal)
            
            ZStack {
                Button {
                    withAnimation {
                        pressNotificationButton()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 35)
                        .foregroundStyle(.white.opacity(0.15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 35)
                                .strokeBorder(linearBorderGradient, lineWidth: 1)
                        }
                }
                
                Label("设置提醒", systemImage: "bell")
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(width: 180, height: 70)
            .padding(.vertical)
        }
        .frame(maxHeight: .infinity)
        
    }
}

//MARK: - Functions
extension AddNewHabitView {
    func pressNextButton() {
        if state < 7 {
            // Save and finish
            if state == 5 {
                let newHabit = Habit(name: self.name, detail: self.detail, iconSystemName: self.iconSystemName, accentColor: Color(hex: accentColorHex)!, requiredCompletion: self.requiredCompletion)
                modelContext.insert(newHabit)
                
                self.isPresented.toggle()
                return
            }
            
            // Detect value validity
            if state == 1 && self.name.count < 1 { // name
                return
            }
            if state == 2 && self.detail.count < 1 { // detail
                return
            }
            
            self.state += 1
            
            // Text field focus state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if (state == 1) { self.focusOnName = true }
                else if (state == 2) { self.focusOnDetail = true }
            }
        }
    }
    
    func pressBackButton() {
        if self.state > 0 {
            // Exit process
            if self.state == 1 {
                self.isPresented.toggle()
                return
            }
            
            self.state -= 1;
            
            // Text field focus state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if (state == 1) { self.focusOnName = true }
                else if (state == 2) { self.focusOnDetail = true }
            }
        }
    }
    
    func pressNotificationButton() {
        
    }
}

//MARK: - Components
extension AddNewHabitView {
    private var nextButton: some View {
        ZStack {
            Button {
                withAnimation {
                    pressNextButton()
                }
            } label: {
                RoundedRectangle(cornerRadius: 35)
                    .foregroundStyle(colorManager.selectedTheme.secondary)
                    .overlay {
                        RoundedRectangle(cornerRadius: 35)
                            .strokeBorder(linearBorderGradient, lineWidth: 1)
                    }
            }
            
            Text(nextButtonCaption)
                .font(.system(size: 20, weight: .semibold))
        }
        .frame(height: 70)
    }
    
    private var backButton: some View {
        ZStack {
            Button {
                withAnimation {
                    pressBackButton()
                }
            } label: {
                RoundedRectangle(cornerRadius: 35)
                    .foregroundStyle(.white.opacity(0.15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 35)
                            .strokeBorder(linearBorderGradient, lineWidth: 1)
                    }
            }
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
        }
        .frame(height: 70)
    }
    
    private var exitButton: some View {
        ZStack {
            Button {
                withAnimation {
                    pressBackButton()
                }
            } label: {
                RoundedRectangle(cornerRadius: 35)
                    .foregroundStyle(.red.opacity(0.15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 35)
                            .strokeBorder(linearBorderGradient, lineWidth: 1)
                    }
            }
            
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .semibold))
        }
        .frame(height: 70)
    }
    
    private var nextButtonCaption: String {
        if state == 0 {
            return "开始"
        }
        else if state == 5 || state == 7 {
            return "完成"
        }
        return "下一步"
    }
    
    private var textFieldBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white.opacity(0.03))
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        }
    }
}

//#Preview {
//    ZStack {
//        Color(.accentBackground)
//            .ignoresSafeArea()
////        AddNewHabitView(state: 3)
//    }
//}
