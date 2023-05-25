//
//  RyukyokuModalView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/06.
//

import SwiftUI

struct RyukyokuModalView: View {
    let memberName: [String]
    let tenpaiData = ["ノーテン", "テンパイ"]
    @State private var tenpaiArray = ["ノーテン", "ノーテン", "ノーテン", "ノーテン"]
    
    @ObservedObject var fieldDataModel: FieldDataModel
    @ObservedObject var fieldState: FieldState

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT > 800 ? Config.UI.HEIGHT * 0.38 : Config.UI.HEIGHT * 0.47)
                .foregroundColor(Color.white)
                .cornerRadius(32, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            VStack {
                ForEach((Config.Member.TON...Config.Member.PEI), id:\.self) { i in
                    HStack {
                        //Spacer()
                        Text(memberName[i])
                            .frame(width: 100, height: 40)
                            .font(.custom(Config.UI.BOLD, size: 18))
                            .foregroundColor(Color.black)
                        Picker(selection: $tenpaiArray[i], label: Text("Picker"), content: {
                            ForEach(tenpaiData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
                        .frame(width: 150)
                        //Spacer()
                    }
                }
                Button(action: {
                    fieldDataModel.preSave()
                    let tenpaiCount = tenpaiArray.filter({ $0 == "テンパイ"}).count
                    
                    fieldDataModel.executeeeRyukyoku(tenpaiCount: tenpaiCount, tenpaiArray: tenpaiArray)
                    
                    resetTenpaiArray()
                    
                    fieldState.updateIsRyukyokuMode(value: false)
                }) {
                    Text("罰符精算")
                        .font(.custom(Config.UI.REGULAR, size: 18))
                        .frame(width: 250, height: 40)
                        .foregroundColor(Color(.white))
                        .background(Color("Background"))
                        .cornerRadius(20)
                        .padding()
                        //.shadow(radius: 8)
                }
            }
            Button(action: {
                fieldState.updateIsRyukyokuMode(value: false)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.custom(Config.UI.REGULAR, size: 35))
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Background"))
            }
            .offset(x: -Config.UI.WIDTH / 2 + 36, y: Config.UI.HEIGHT > 800 ? -Config.UI.HEIGHT * 0.38 / 2 + 32 : -Config.UI.HEIGHT * 0.47 / 2 + 32)
        }
        .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT, alignment: .bottom)
        .offset(x: 0, y: fieldState.isRyukyokuMode ? 0 : 500)
        .animation(.default, value: fieldState.isRyukyokuMode)
    }
    
    private func resetTenpaiArray() {
        for i in Config.Member.TON...Config.Member.PEI {
            tenpaiArray[i] = "ノーテン"
        }
    }
}

struct RyukyokuModalView_Previews: PreviewProvider {
    static var previews: some View {
        RyukyokuModalView(memberName: ["だいげん", "しょうさん", "いーそー", "いさんげ"], fieldDataModel: FieldDataModel(), fieldState: FieldState())
    }
}
