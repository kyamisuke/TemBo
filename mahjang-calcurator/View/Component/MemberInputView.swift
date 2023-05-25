//
//  MemberInputView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/07.
//

import SwiftUI
import Combine

struct MemberInputView: View {
    @Binding var nameLengthJudges: [Bool]
    @Binding var memberName: [String]
    @FocusState var focusedField: Enum.Field?
    let i: Int
    
    var body: some View {
        VStack {
            Text(Config.Member.KAZE[i])
                .frame(width: Config.UI.INPUT_WIDTH, height: 40, alignment: .leading)
                .font(.custom(Config.UI.BOLD, size: 24))
                .foregroundColor(Color.white)
            if nameLengthJudges[i] {
                Text("※5文字以内に納めてください")
                    .frame(width: Config.UI.INPUT_WIDTH, height: 12, alignment: .leading)
                    .font(.custom(Config.UI.BOLD, size: 12))
                    .foregroundColor(Color.error)
            }
            TextField("なまえ（5文字以内）",
                      text: $memberName[i],
                      onCommit: {
                let new = i < 3 ? Enum.Field.allCases[i+1] : nil
                focusedField = new
                })
                .focused($focusedField, equals: Enum.Field.allCases[i])
                .onReceive(Just(memberName[i])) {_ in
                    nameLengthJudges[i] = memberName[i].count > 5
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: Config.UI.INPUT_WIDTH)
                .font(.custom(Config.UI.REGULAR, size: 18))
                .foregroundColor(nameLengthJudges[i] ? Color.error : Color.textBlack)
        }
//        .offset(x: 0, y: getOffset(i))
        .opacity(getOpacity(i))
        .animation(.default, value: focusedField == Enum.Field.allCases[i] || nil == focusedField)
    }
    
    private func getOffset(_ i: Int) -> CGFloat {
        return Enum.Field.allCases[i] == focusedField ? CGFloat(-132 * i) : 0
    }
    private func getOpacity(_ i: Int) -> Double {
        return Enum.Field.allCases[i] == focusedField || nil == focusedField ? 1.0 : 0.2
    }
}

struct MemberInputView_Previews: PreviewProvider {
    static var previews: some View {
        MemberInputView(nameLengthJudges: Binding.constant([false, false, false, false]), memberName: Binding.constant(["", "", "", ""]), i: 0)
    }
}
