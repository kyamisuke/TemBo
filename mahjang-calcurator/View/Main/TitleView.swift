//
//  TitleView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/17.
//

import SwiftUI
import Combine

struct TitleView: View {
    let width:CGFloat = 280
    
    @State private var path = [String]()
    //    @State private var ton:String = ""
    //    @State private var nan:String = ""
    //    @State private var sha:String = ""
    //    @State private var pei:String = ""
    @State var memberName = ["", "", "", ""]
    
    @State var isPresented: Bool = false
    
    @State var isAlert = false
    @State var nameLengthJudges = [false, false, false, false]
    
    @FocusState var focusedField: Enum.Field?
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Title")]), startPoint: .top, endPoint: .trailing)
                    .ignoresSafeArea()      // フレームサイズをセーフエリア外まで広げる
                VStack() {
                    //Spacer()
                    Text("対局者入力")
                        .font(.custom(Config.UI.BOLD, size: 40))
                        .frame(width: Config.UI.WIDTH, height: 64)
                        .foregroundColor(Color.white)
                        .padding()
                    //Spacer()
                    Group {
                        ForEach(0..<4) { i in
                            MemberInputView(nameLengthJudges: $nameLengthJudges, memberName: $memberName, focusedField: _focusedField, i: i)
                                .zIndex(focusedField == Enum.Field.allCases[i] ? 99 : 1)
                            if i != 3 {
                                Rectangle()
                                    .foregroundColor(Color(white: 0.3, opacity: 0.6))
                                    .frame(width: width + 40, height: 2)
                                    .padding(15)
                            }
                        }
                        Button(action: {
                            if memberName.contains("") {
                                isAlert = true
                            } else if !nameLengthJudges.contains(true) {
                                isPresented = true
                            }
                            focusedField = nil
                        }) {
                            Text("対局開始")
                                .font(.custom(Config.UI.BOLD, size: 20))
                                .frame(width: 280, height: 48)
                                .foregroundColor(Color("Background"))
                                .background(Color(.white))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color("Background"), lineWidth: 1.0)
                                )
                            //.shadow(radius: 8)
                        }
                        .alert(isPresented: $isAlert) {
                            Alert(title: Text("おや？"),
                                  message: Text("どうやら空白の欄があるようです"),
                                  dismissButton: .default(Text("戻る")))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
//                Rectangle()
//                    .frame(width: Config.UI.WIDTH, height: Config.UI.HEIGHT)
//                    .ignoresSafeArea()
//                    .foregroundColor(Color(white: 0, opacity: focusedField != nil ? 0.5 : 0))
//                    .animation(.default, value: focusedField != nil)
//                    .onTapGesture(perform: {
//                        focusedField = nil
//                    })
                if isPresented {
                    BattleView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), memberName: memberName, isPresented: $isPresented)
                }
            }
            .frame(width: Config.UI.WIDTH)
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
