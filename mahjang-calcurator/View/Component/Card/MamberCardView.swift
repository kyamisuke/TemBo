//
//  MamberCardView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/03.
//

import SwiftUI

struct MamberCardView: View {
    @ObservedObject var fieldDataModel: FieldDataModel
    @ObservedObject var fieldState: FieldState
    let memberNum: Int
    let memberName: [String]
    let rot: [Double] = [0, -90, 180, 90]
    
    var body: some View {
        VStack {
            Image(fieldDataModel.isOya(member: memberNum) ? "OyaMark" : "NoOyaMark")
                .frame(height: Config.UI.OYA_MARK_HEIGHT)
                .animation(.default, value: fieldDataModel.isOya(member: memberNum))
            Text(memberName[memberNum])
                .font(.custom(Config.UI.BOLD, size: Config.UI.MEMBER_TEXT_SIZE))
                .frame(width: getCardWidth(str: memberName[memberNum]), height: Config.UI.CARD_HEIGHT)
                .foregroundColor(Color.textBlack)
                .background(fieldDataModel.isReach(member: memberNum) ? Color.reach : .white)
                .cornerRadius(8)
                .shadow(radius: 8, x: -8, y: -8)
                .onTapGesture(perform: {
                    fieldDataModel.toggleReachState(member: memberNum)
                })
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged{ value in
                            fieldState.isChoiced = true
                            fieldState.start = value.startLocation + Config.UI.TOUCH_OFFSET
                            fieldState.end = value.location + Config.UI.TOUCH_OFFSET
                            fieldDataModel.updateAgari(agari: memberNum)
                            fieldState.positionCheck()
                        }
                        .onEnded{ value in
                            fieldState.overlayCheck()
                        }
                )
                .scaleEffect(fieldState.overlay == memberNum ? 1.2 : 1)
                .animation(.default, value: fieldState.overlay == memberNum)
                .animation(.easeOut(duration: 0.2), value: fieldDataModel.reachArray[memberNum])
            Text("\(fieldDataModel.scores[memberNum])")
                .frame(height: 16)
                .font(.custom(Config.UI.BOLD, size: Config.UI.SCORE_TEXT_SIZE))
                .foregroundColor(Color.white)
                .shadow(radius: 4, x: -8, y: -8)
                .padding(.bottom, 12)
        }
        .rotationEffect(.degrees(rot[memberNum]))
    }
    
    private func getCardWidth(str: String) -> CGFloat {
        return CGFloat(str.count) * Config.UI.LENGTH_EACH_STRING < Config.UI.MIN_CARD_WIDTH ? Config.UI.MIN_CARD_WIDTH : CGFloat(str.count) * Config.UI.LENGTH_EACH_STRING
    }
}

struct MamberCardView_Previews: PreviewProvider {
    static var previews: some View {
        MamberCardView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), memberNum: Config.Member.TON, memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"])
    }
}
