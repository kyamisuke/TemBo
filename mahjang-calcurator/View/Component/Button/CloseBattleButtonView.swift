//
//  CloseBattleButtonView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/06.
//

import SwiftUI

struct CloseBattleButtonView: View {
    @Binding var isAlert: Bool
    @Binding var isPresented: Bool
    @Binding var isContinue: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isAlert = true
            }) {
                Image(systemName: "xmark")
                    .font(.custom(Config.UI.REGULAR, size: 18))
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color("Background"))
                    .background(Color(.white))
                    .cornerRadius(24)
                    //.shadow(radius: 6, x: 6, y: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color("Background"), lineWidth: 3.0)
                    )
            }
            .alert(isPresented: $isAlert) {
                Alert(title: Text("終了の時間ですか？"),
                      message: Text("現在の状況は保存されません。\n本当に終了しますか？"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .destructive(Text("終了"), action: {
                    withAnimation(.linear) {
                        isPresented = false
                        isContinue = true
                    }
                }))
            }
            Spacer()
        }
        .frame(width: Config.UI.WIDTH * 0.9, height: Config.UI.HEIGHT * 0.9, alignment: .topLeading)
    }
}

struct CloseBattleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseBattleButtonView(isAlert: Binding.constant(false), isPresented: Binding.constant(true), isContinue: Binding.constant(true))
    }
}
