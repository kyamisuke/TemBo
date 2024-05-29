//
//  BattleView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/18.
//

import SwiftUI

struct BattleView: View {
    @ObservedObject var fieldDataModel: FieldDataModel
    @ObservedObject var fieldState: FieldState
    
    let memberName: [String]
        
    @State var han:Int = 1
    @State var fu:Int = 30
        
    @State var opacity: Double = 0
    @Binding var isPresented: Bool
    @Binding var isContinue: Bool
    
    @State var isAlert = false
        
    var dragPoint: some View {
        Circle()
            .fill(Color.arrow)
            .frame(width: 48, height: 48)
            .position(x: fieldState.end.x, y: fieldState.end.y)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Title")]), startPoint: .top, endPoint: .trailing)
                .ignoresSafeArea()      // フレームサイズをセーフエリア外まで広げる
            
            if fieldState.isChoiced {
                Path { path in
                    path.move(to: fieldState.start)        // 始点移動
                    path.addLine(to: fieldState.end)   // 直線描画
                }
                .stroke(lineWidth: 10)
                .fill(Color.arrow)
                dragPoint
            }
            Group {
                VStack {
                    Spacer()
                    MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.SHA, memberName: memberName)
                    Spacer()
                    ZStack {
                        MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.PEI, memberName: memberName)
                            .offset(x: -Config.UI.WIDTH * 0.3, y: 0)
                        MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.NAN, memberName: memberName)
                            .offset(x: Config.UI.WIDTH * 0.3, y: 0)
                    }
                    
                    Spacer()
                    MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.TON, memberName: memberName)
                    Spacer()
                }
            }
            
            CenterInformationView(fieldState: fieldState, fieldDataModel: fieldDataModel)
            
            CloseBattleButtonView(isAlert: $isAlert, isPresented: $isPresented, isContinue: $isContinue)
            
            ReturnButtonView(fieldDataModel: fieldDataModel)
            
            Rectangle()
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT)
                .ignoresSafeArea()
                .foregroundColor(Color(white: 0, opacity: fieldState.isInputMode || fieldState.isRyukyokuMode ? 0.5 : 0))
                .animation(.default, value: fieldState.isInputMode || fieldState.isRyukyokuMode)
                .onTapGesture(perform: {
                    fieldState.updateIsInputMode(value: false)
                    fieldState.updateIsRyukyokuMode(value: false)
                    fieldState.overlayReset()
                })
        
            CalcurateModalView(fieldDataModel: fieldDataModel, fieldState: fieldState, han: $han, fu: $fu, memberName: memberName)
                
            RyukyokuModalView(memberName: memberName, fieldDataModel: fieldDataModel, fieldState: fieldState)
        }
        .opacity(self.opacity)
        .onAppear {
            withAnimation(.linear(duration: 0.3)) {
                // NOTE: opacityを変更する画面再描画に対してアニメーションを適用する
                self.opacity = 1.0
            }
        }
    }
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        BattleView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"], isPresented: Binding.constant(true), isContinue: Binding.constant(false))
    }
}
