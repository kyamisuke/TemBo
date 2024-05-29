//
//  TitleView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/17.
//

import SwiftUI
import Combine

struct TitleView: View {
    enum Field: CaseIterable {
        case ton
        case nan
        case sha
        case pei
    }
    
    let width:CGFloat = 280
    
    @State private var path = [String]()
//    @State private var ton:String = ""
//    @State private var nan:String = ""
//    @State private var sha:String = ""
//    @State private var pei:String = ""
    @State var memberName = ["", "", "", ""]
    let kaze = ["東家（起家）", "南家", "西家", "北家"]
    
    @State var isPresented: Bool = false
    
    @State var isAlert = false
    @State var nameLengthJudges = [false, false, false, false]
    
    @FocusState private var focusedField: Field?
    
    @State var isContinue = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Title")]), startPoint: .top, endPoint: .trailing)
                .ignoresSafeArea()      // フレームサイズをセーフエリア外まで広げる
            VStack() {
                //Spacer()
                Text("対局者入力")
                    .font(.custom("ShipporiMincho-Bold", size: 40))
                    .frame(width: 450, height: 64)
                    .foregroundColor(Color.white)
                    .padding()
                //.background(Color("Title"))
                Spacer()
                ScrollView {
                    Group {
                        ForEach(0..<4) { i in
                            MemberInputView(nameLengthJudges: $nameLengthJudges, memberName: $memberName, i: i)
                            Rectangle()
                                .foregroundColor(Color(white: 0.3, opacity: 0.6))
                                .frame(width: width + 40, height: 2)
                                .padding(10)
                            Spacer()
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
                                .font(.custom("ShipporiMincho-Bold", size: 20))
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

                        if isContinue {
                            Button(action: {
                                let tmpTon = memberName[0]
                                memberName[0] = memberName[1]
                                memberName[1] = memberName[2]
                                memberName[2] = memberName[3]
                                memberName[3] = tmpTon
                            }) {
                                Text("席を回す")
                                    .font(.custom("ShipporiMincho-Bold", size: 16))
                                    .frame(width: 120, height: 40)
                                    .foregroundColor(Color(.white))
                                    .background(Color(.clear))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 1.0)
                                    )
                            }
                            .padding(.bottom, 20)
                            Spacer()
                        }
                    }
                }
            }
            if isPresented {
                BattleView(fieldDataModel: FieldDataModel(), fieldState: FieldState(), memberName: memberName, isPresented: $isPresented, isContinue: $isContinue)
            }
        }
        
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
