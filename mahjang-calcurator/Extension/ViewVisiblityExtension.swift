//
//  ViewVisiblityExtension.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/05/24.
//

import SwiftUI

struct HiddenModifier : ViewModifier {
    let hidden:Bool
    @ViewBuilder
    func body(content: Content) -> some View {
        if hidden {
            content.hidden()
        } else {
            content
        }
    }
}

struct VisibleModifier : ViewModifier {
    let visible:Bool
    @ViewBuilder
    func body(content: Content) -> some View {
        if visible == false {
            EmptyView()
        } else {
            content
        }
    }
}

extension View {
    func visible(_ visible:Bool) -> some View {
        modifier(VisibleModifier(visible: visible))
    }
    func hidden(_ hidden:Bool) -> some View {
        modifier(HiddenModifier(hidden: hidden))
    }
}
