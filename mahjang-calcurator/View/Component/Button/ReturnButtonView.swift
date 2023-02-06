//
//  ReturnButtonView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/06.
//

import SwiftUI

struct ReturnButtonView: View {
    @ObservedObject var fieldDataModel: FieldDataModel
    
    var body: some View {
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
    }
}

struct ReturnButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ReturnButtonView(fieldDataModel: FieldDataModel())
    }
}
