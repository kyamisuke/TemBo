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
                        //Spacer()
                        MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.PEI, memberName: memberName)
                            .offset(x: -Config.UI.WIDTH * 0.3, y: 0)
                        //Spacer(minLength: 140)
                        MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.NAN, memberName: memberName)
                            .offset(x: Config.UI.WIDTH * 0.3, y: 0)
                        //Spacer()
                    }
                    
                    Spacer()
                    MamberCardView(fieldDataModel: fieldDataModel, fieldState: fieldState, memberNum: Config.Member.TON, memberName: memberName)
                    Spacer()
                }
            }
            
            CenterInformationView(fieldState: fieldState, fieldDataModel: fieldDataModel)
            
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
                        }
                    }))
                }
                Spacer()
            }
            .frame(width: Config.UI.WIDTH * 0.9, height: Config.UI.HEIGHT * 0.9, alignment: .topLeading)
            
            VStack {
                Button(action: {
                    fieldDataModel.returnData()
                }) {
                    Image(systemName: "return")
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
                Spacer()
            }
            .frame(width: Config.UI.WIDTH * 0.63, height: Config.UI.HEIGHT * 0.9, alignment: .topLeading)
            
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
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT, alignment: .bottom)
                .offset(x: 0, y: fieldState.isInputMode ? 0 : 500)
                .animation(.default, value: fieldState.isInputMode)
            RyukyokuModalView(memberName: memberName, fieldDataModel: fieldDataModel, fieldState: fieldState)
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT, alignment: .bottom)
                .offset(x: 0, y: fieldState.isRyukyokuMode ? 0 : 500)
                .animation(.default, value: fieldState.isRyukyokuMode)
                
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
        BattleView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"], isPresented: Binding.constant(true))
    }
}
