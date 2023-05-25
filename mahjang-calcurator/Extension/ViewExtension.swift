//
//  ViewExtension.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/05/22.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask) -> some View {
        self.modifier(PartlyRoundedCornerModifier(cornerRadius: radius,
                                                  maskedCorners: maskedCorners))
    }
}

struct PartlyRoundedCornerView: UIViewRepresentable {
    let cornerRadius: CGFloat
    let maskedCorners: CACornerMask

    func makeUIView(context: UIViewRepresentableContext<PartlyRoundedCornerView>) -> UIView {
        // 引数で受け取った値を利用して、一部の角のみを丸くしたViewを作成する
        let uiView = UIView()
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.maskedCorners = maskedCorners
        uiView.backgroundColor = .white
        return uiView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PartlyRoundedCornerView>) {
    }
}

struct PartlyRoundedCornerModifier: ViewModifier {
    let cornerRadius: CGFloat
    let maskedCorners: CACornerMask

    func body(content: Content) -> some View {
        content.mask(PartlyRoundedCornerView(cornerRadius: self.cornerRadius,
                                             maskedCorners: self.maskedCorners))}
}
