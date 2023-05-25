//
//  DoubleRonCalcurateModalView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/05/24.
//

import SwiftUI

struct DoubleRonCalcurateModalView: View {
    @ObservedObject var fieldDataModel: FieldDataModel
    @ObservedObject var fieldState: FieldState
    
    @Binding var han:Int
    @Binding var fu:Int
    
    @State var calcurator = Calcurator()
    
    let memberName: [String]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT * 0.35)
                .foregroundColor(Color.white)
                .cornerRadius(32, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            PageView([
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
                    }
                },
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
                    }
                }
            ])
        }
        .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT, alignment: .bottom)
//        .offset(x: 0, y: fieldState.isInputMode ? 0 : 500)
        .animation(.default, value: fieldState.isInputMode)
    }
    
    private func getOverlayName() -> String {
        return fieldState.overlayPlayer != -1 ? (fieldState.overlayPlayer != fieldDataModel.agari ? memberName[fieldState.overlayPlayer] : "ツモ") : ""
    }
    
    private func isTsumo() -> Bool {
        return getOverlayName() == "ツモ"
    }
}

struct DoubleRonCalcurateModalView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleRonCalcurateModalView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), han: Binding.constant(1), fu: Binding.constant(30), memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"])
    }
}
