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
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT > 800 ? Config.UI.HEIGHT * 0.35 : Config.UI.HEIGHT * 0.4)
                .foregroundColor(Color.white)
                .cornerRadius(32)
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
                            .frame(width: Config.UI.BLOCK)
                        }
                    }
                    Group() {
                        if calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getError().isEmpty && isTsumo() {
                            Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getTsumoScoreString(isOya: fieldDataModel.agariIsOya()))")
                                .frame(width: 300, height: 30)
                                .font(.custom(Config.UI.BOLD, size: 24))
                                .foregroundColor(Color.black)
                        }
                        if calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getError().isEmpty && !isTsumo() {
                            Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getScore())点")
                                .frame(width: Config.UI.BLOCK*2, height: 30)
                                .font(.custom(Config.UI.BOLD, size: 24))
                                .foregroundColor(Color.black)
                        }
                        if !calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.agariIsOya()).getError().isEmpty {
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
                    }) {
                        Text("点数計算")
                            .font(.custom(Config.UI.REGULAR, size: 18))
                            .frame(width: 250, height: 40)
                            .foregroundColor(Color(.white))
                            .background(Color("Background"))
                            .cornerRadius(20)
                            .padding()
                    }
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
            .offset(x: -Config.UI.WIDTH / 2 + 36, y: Config.UI.HEIGHT > 800 ? -Config.UI.HEIGHT * 0.32 / 2 + 32 : -Config.UI.HEIGHT * 0.4 / 2 + 32)
        }
    }
    
    private func getOverlayName() -> String {
        return fieldState.overlayPlayer != -1 ? (fieldState.overlayPlayer != fieldDataModel.agari ? memberName[fieldState.overlayPlayer] : "ツモ") : ""
    }
    
    private func isTsumo() -> Bool {
        return getOverlayName() == "ツモ"
    }
}

struct CalcurateModalView_Previews: PreviewProvider {
    static var previews: some View {
        CalcurateModalView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), han: Binding.constant(1), fu: Binding.constant(30), memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"])
    }
}
