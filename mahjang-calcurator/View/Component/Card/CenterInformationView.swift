//
//  CenterInformationView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/03.
//

import SwiftUI

struct CenterInformationView: View {
    @ObservedObject var fieldState: FieldState
    @ObservedObject var fieldDataModel: FieldDataModel
    
    var body: some View {
        VStack {
            Text("\(Config.UI.BAKAZE_DATA[fieldDataModel.bakaze / 4])\(fieldDataModel.bakaze % 4 + 1)局")
                .font(.custom(Config.UI.BOLD, size: 32))
                .foregroundColor(Color.white)
                .frame(height: 28)
                .shadow(radius: 8)
            Text("\(fieldDataModel.honba)本場")
                .font(.custom(Config.UI.BOLD, size: 20))
                .foregroundColor(Color.white)
                .shadow(radius: 10)
            VStack {
                Text("供託: \(fieldDataModel.kyoutaku)点")
                    .font(.custom(Config.UI.BOLD, size: 16))
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
            }
            Button(action: {
                fieldState.updateIsRyukyokuMode(value: true)
            }) {
                Text("流局")
                    .font(.custom(Config.UI.BOLD, size: 16))
                    .frame(width: 60, height: 30)
                    .foregroundColor(Color("Background"))
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Background"), lineWidth: 2.0)
                    )
                    //.shadow(radius: 8, x: 8, y: 8)
            }
        }
    }
}

struct CenterInformationView_Previews: PreviewProvider {
    static var previews: some View {
        CenterInformationView(fieldState: FieldState(), fieldDataModel: FieldDataModel())
    }
}
