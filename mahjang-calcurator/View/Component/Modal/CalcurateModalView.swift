//
//  CalcurateModalView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/04.
//

import SwiftUI

struct CalcurateModalView: View {
    @ObservedObject var fieldDataModel: FieldDataModel
    @ObservedObject var fieldState: FieldState
    
    @Binding var han:Int
    @Binding var fu:Int
    
    @State var calcurator = Calcurator()
    
    let memberName: [String]
    @State var haraiCount: Int = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT * 0.43)
                .foregroundColor(Color.white)
                .cornerRadius(32, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            Group() {
                VStack {
                    Group() {
                        HStack {
                            VStack {
                                Text("しはらい")
                                    .frame(width: 100, height: 5)
                                    .font(.custom(Config.UI.REGULAR, size: 12))
                                    .foregroundColor(Color.black)
                                Text("\(getOverlayName())")
                                    .frame(height: 30)
                                    .font(.custom(Config.UI.BOLD, size: 22))
                                    .foregroundColor(Color.black)
                            }
                            Text("→")
                                .frame(width: 30, height: 40)
                                .font(.custom(Config.UI.BOLD, size: 24))
                                .foregroundColor(Color.black)
                            VStack {
                                Text("あがり")
                                    .frame(width: 100, height: 5)
                                    .font(.custom(Config.UI.REGULAR, size: 12))
                                    .foregroundColor(Color.black)
                                Text("\(memberName[fieldDataModel.agari])")
                                    .frame(height: 30)
                                    .font(.custom(Config.UI.BOLD, size: 22))
                                    .foregroundColor(Color.black)
                            }
                        }
                        HStack {
                            Text("翻")
                                .frame(width: Config.UI.BLOCK/2, height: 20, alignment: .center)
                                .font(.custom(Config.UI.REGULAR, size: 20))
                                .foregroundColor(Color.black)
                            Picker(selection: $han, label: Text("Picker"), content: {
                                ForEach(Config.System.HAN_DATA, id:\.self) { value in
                                    Text("\(value)")
                                        .tag(value)
                                }
                            })
                            .onChange(of: han) { _ in
                                calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya())
                            }
                            .frame(width: Config.UI.BLOCK)
                        }

                        HStack {
                            Text("符")
                                .frame(width: Config.UI.BLOCK/2, height: 20)
                                .font(.custom(Config.UI.REGULAR, size: 20))
                                .foregroundColor(Color.black)
                            Picker(selection: $fu, label: Text("Picker"), content: {
                                ForEach(Config.System.FU_DATA, id:\.self) { value in
                                    Text("\(value)")
                                        .tag(value)
                                }
                            })
                            .onChange(of: fu) { _ in
                                calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya())
                            }
                            .frame(width: Config.UI.BLOCK)
                        }
                    }
                    Group() {
                        if !calcurator.isError() && isTsumo() {
                            Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getTsumoScoreString(isOya: fieldDataModel.agariIsOya()))")
                                .frame(width: 300, height: 30)
                                .font(.custom(Config.UI.BOLD, size: 24))
                                .foregroundColor(Color.black)
                        }
                        if !calcurator.isError() && !isTsumo() {
                            Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getScore())点")
                                .frame(width: Config.UI.BLOCK*2, height: 30)
                                .font(.custom(Config.UI.BOLD, size: 24))
                                .foregroundColor(Color.black)
                        }
                        if calcurator.isError() {
                            Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getError())")
                                .frame(height: 30)
                                .font(.custom(Config.UI.BOLD, size: 18))
                                .foregroundColor(Color.error)
                        }
                    }
                    Button(action: {
                        calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya())
                        if !calcurator.getError().isEmpty {
                            return
                        }

                        fieldDataModel.preSave()
                        fieldDataModel.executeScore(isTsumo: isTsumo(), score: calcurator.getScore(), harai: fieldState.overlay)

                        fieldState.updateIsInputMode(value: false)
                        fieldDataModel.kyoutaku = 0
                        fieldDataModel.reachReset()
                        fieldState.overlayReset()
                        fieldState.isMultiRonMode = false
                        fieldState.preOverlay = -1
                        haraiCount = 0
                    }) {
                        Text("清算終了")
                            .font(.custom(Config.UI.REGULAR, size: 18))
                            .frame(width: 250, height: 40)
                            .foregroundColor(Color(.white))
                            .background(Color("Background"))
                            .cornerRadius(20)
                            .padding(10)
                    }
                    Button(action: {
                        calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya())
                        if !calcurator.getError().isEmpty {
                            return
                        }

                        fieldDataModel.preSave()
                        fieldDataModel.executeScore(isTsumo: isTsumo(), score: calcurator.getScore(), harai: fieldState.overlay, toNext: false)

                        fieldState.updateIsInputMode(value: false)
                        fieldState.overlayReset()
                        fieldState.isMultiRonMode = true
                        haraiCount += 1
                    }) {
                        Text("他の清算を続ける")
                            .font(.custom(Config.UI.REGULAR, size: 18))
                            .frame(width: 250, height: 40)
                            .foregroundColor(Color("Background"))
                            .background(Color(.white))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Background"), lineWidth: 2)
                            )
                            .padding(5)
                    }
                    .opacity(isDisable() ? 0.35 : 1.0)
                    .disabled(isDisable())
                }
            }
            Button(action: {
                fieldState.updateIsInputMode(value: false)
                fieldState.overlayReset()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.custom(Config.UI.REGULAR, size: 35))
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Background"))
            }
            .offset(x: -Config.UI.WIDTH / 2 + 36, y: -Config.UI.HEIGHT * 0.43 / 2 + 32)
        }
        .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT, alignment: .bottom)
        .offset(x: 0, y: fieldState.isInputMode ? 0 : 500)
        .animation(.default, value: fieldState.isInputMode)
    }
    
    private func getOverlayName() -> String {
        return fieldState.overlayPlayer != -1 ? (fieldState.overlayPlayer != fieldDataModel.agari ? memberName[fieldState.overlayPlayer] : "ツモ") : ""
    }
    
    private func isTsumo() -> Bool {
        return getOverlayName() == "ツモ"
    }
    
    private func isDisable() -> Bool {
        return isTsumo() || haraiCount == 2
    }
}

struct CalcurateModalView_Previews: PreviewProvider {
    static var previews: some View {
        CalcurateModalView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), han: Binding.constant(1), fu: Binding.constant(30), memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"])
            .previewDevice("iPhone 13 Pro")
    }
}
