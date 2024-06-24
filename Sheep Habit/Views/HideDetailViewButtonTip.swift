//
//  HideDetailViewButtonTip.swift
//  Sheep Habit
//
//  Created by 王飞扬 on 2024/6/19.
//

import TipKit

struct HideDetailViewButton: Tip {
    
    var title: Text {
        Text("隐藏详情页")
    }
    var message: Text? {
        Text("点击此处以收起详情页")
    }
    var image: Image? {
        Image(systemName: "lightbulb")
    }
}
