//
//  BattleView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/18.
//

import SwiftUI

struct BattleView: View {
    @State private var calcurator = Calcurator()
    @ObservedObject private var fieldDataModel = FieldDataModel()
    
    @Binding var memberName: [String]
    
    let hanData = [1,2,3,4,5,6,7,8,9,10,11,12,13]
    let fuData = [20,25,30,40,50,60,70,80,90,100,110]
    let tenpaiData = ["ノーテン", "テンパイ"]
    let bakazeData = ["東", "南"]
    @State private var tenpaiArray = ["ノーテン", "ノーテン", "ノーテン", "ノーテン"]
    @State private var overlay = -1
    @State private var overlayPlayer = -1
    @State private var agari = 0
    @State private var isInputMode = false
    @State private var isRyukyokuMode = false
    
    @State private var isChoiced = false
    @State private var start = CGPoint(x: 0, y: 0)
    @State private var end = CGPoint(x: 0, y: 0)
    @State var han:Int = 1
    @State var fu:Int = 30
    
    @State var directScore = "0"
    
    @State var opacity: Double = 0
    @Binding var isPresented: Bool
    
    @State var isAlert = false
    
    private let offset = CGPoint(x: 40, y: -15)
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    private let leftVert = UIScreen.main.bounds.width/3
    private let rightVert = UIScreen.main.bounds.width/3*2
    private let topHori = UIScreen.main.bounds.height/3*2
    private let bottomHori = UIScreen.main.bounds.height/3
    private let imageHeight:CGFloat = 32
    private let block:CGFloat = 80
    private let BOLD = "ShipporiMincho-Bold"
    private let REGULAR = "ShipporiMincho-Regular"
    private let MEMBER_TEXT_SIZE:CGFloat = 22
    private let SCORE_TEXT_SIZE:CGFloat = 18
    private let CARD_HEIGHT:CGFloat = 50
    
    var shaView: some View {
        Group {
            VStack {
                Image(fieldDataModel.isOya(member: Config.Member.SHA) ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: fieldDataModel.isOya(member: Config.Member.SHA))
                Text(memberName[Config.Member.SHA])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[Config.Member.SHA]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(fieldDataModel.isReach(member: Config.Member.SHA) ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: -8, y: -8)
                    .onTapGesture(perform: {
                        fieldDataModel.toggleReachState(member: Config.Member.SHA)
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = Config.Member.SHA
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == Config.Member.SHA ? 1.2 : 1)
                    .animation(.default, value: overlay == Config.Member.SHA)
                    .animation(.easeOut(duration: 0.2), value: fieldDataModel.reachArray[Config.Member.SHA])
                Text("\(fieldDataModel.scores[Config.Member.SHA])")
                    .frame(height: 16)
                    .font(.custom(BOLD, size: SCORE_TEXT_SIZE))
                    .foregroundColor(Color.white)
                    .shadow(radius: 4, x: -8, y: -8)
                    .padding(.bottom, 12)
            }
            .rotationEffect(.degrees(180))
        }
    }
    
    var peiView: some View {
        Group {
            VStack {
                Image(fieldDataModel.isOya(member: Config.Member.PEI) ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: fieldDataModel.isOya(member: Config.Member.PEI))
                Text(memberName[Config.Member.PEI])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[Config.Member.PEI]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(fieldDataModel.reachArray[Config.Member.PEI] ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: 8, y: -8)
                    .onTapGesture(perform: {
                        fieldDataModel.toggleReachState(member: Config.Member.PEI)
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = Config.Member.PEI
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == Config.Member.PEI ? 1.2 : 1)
                    .animation(.default, value: overlay == Config.Member.PEI)
                    .animation(.easeOut(duration: 0.2), value: fieldDataModel.reachArray[Config.Member.PEI])
                Text("\(fieldDataModel.scores[Config.Member.PEI])")
                    .frame(height: 16)
                    .font(.custom(BOLD, size: SCORE_TEXT_SIZE))
                    .foregroundColor(Color.white)
                    .shadow(radius: 4, x: 8, y: -8)
                    .padding(.bottom, 12)
            }
            .rotationEffect(.degrees(90))
        }
    }
    
    var nanView: some View {
        Group {
            VStack {
                Image(fieldDataModel.isOya(member: Config.Member.NAN) ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: fieldDataModel.isOya(member: Config.Member.NAN))
                Text(memberName[Config.Member.NAN])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[Config.Member.NAN]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(fieldDataModel.reachArray[Config.Member.NAN] ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: -8, y: 8)
                    .onTapGesture(perform: {
                        fieldDataModel.toggleReachState(member: Config.Member.NAN)
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = Config.Member.NAN
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == Config.Member.NAN ? 1.2 : 1)
                    .animation(.default, value: overlay == Config.Member.NAN)
                    .animation(.easeOut(duration: 0.2), value: fieldDataModel.reachArray[Config.Member.NAN])
                Text("\(fieldDataModel.scores[Config.Member.NAN])")
                    .frame(height: 16)
                    .font(.custom(BOLD, size: SCORE_TEXT_SIZE))
                    .foregroundColor(Color.white)
                    .shadow(radius: 4, x: -8, y: 8)
                    .padding(.bottom, 12)
            }
            .rotationEffect(.degrees(-90))
        }
    }
    
    var tonView: some View {
        Group {
            ZStack {
                VStack {
                    Image(fieldDataModel.isOya(member: Config.Member.TON) ? "OyaMark" : "NoOyaMark")
                        .frame(height: imageHeight)
                        .animation(.default, value: fieldDataModel.isOya(member: Config.Member.TON))
                    Text(memberName[Config.Member.TON])
                        .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                        .frame(width: getCardWidth(str: memberName[Config.Member.TON]), height: CARD_HEIGHT)
                        .foregroundColor(Color.textBlack)
                        .background(fieldDataModel.reachArray[Config.Member.TON] ? Color.reach : .white)
                        .cornerRadius(8)
                        .shadow(radius: 8, x: 8, y: 8)
                        .onTapGesture(perform: {
                            fieldDataModel.toggleReachState(member: Config.Member.TON)
                        })
                        .gesture(
                            DragGesture(coordinateSpace: .global)
                                .onChanged{ value in
                                    isChoiced = true
                                    start = value.startLocation + offset
                                    end = value.location + offset
                                    agari = Config.Member.TON
                                    positionCheck()
                                }
                                .onEnded{ value in
                                    overlayCheck()
                                }
                        )
                        .scaleEffect(overlay == Config.Member.TON ? 1.2 : 1)
                        .animation(.default, value: overlay == Config.Member.TON)
                        .animation(.easeOut(duration: 0.2), value: fieldDataModel.reachArray[Config.Member.TON])
                    Text("\(fieldDataModel.scores[Config.Member.TON])")
                        .frame(height: 16)
                        .font(.custom(BOLD, size: SCORE_TEXT_SIZE))
                        .foregroundColor(Color.white)
                        .shadow(radius: 4, x: 8, y: 8)
                        .padding(.bottom, 12)
                }
//                HStack {
//                    Rectangle()
//                        .frame(width: 2, height: 15)
//                        .rotationEffect(.degrees(-15))
//                    Text("リーチ！")
//                        .frame(height: 16)
//                        .font(.custom(BOLD, size: 18))
//                        .padding(-5)
//                    Rectangle()
//                        .frame(width: 2, height: 15)
//                        .rotationEffect(.degrees(15))
//                }
//                .offset(x: 50, y: -65)
//                .rotationEffect(.degrees(20))
//                .foregroundColor(Color.reach)
            }
            .rotationEffect(.degrees(0))
        }
    }
    
    var dragPoint: some View {
        Circle()
            .fill(Color.arrow)
            .frame(width: 48, height: 48)
            .position(x: end.x, y: end.y)
    }
    
    var calcurateModal: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height > 800 ? height * 0.35 : height * 0.4)
                .foregroundColor(Color.white)
                .cornerRadius(32)
            VStack {
                HStack {
                    VStack {
                        Text("しはらい")
                            .frame(width: 100, height: 5)
                            .font(.custom(REGULAR, size: 12))
                            .foregroundColor(Color.black)
                        Text("\(getOverlayName())")
                            .frame(height: 30)
                            .font(.custom(BOLD, size: 22))
                            .foregroundColor(Color.black)
                    }
                    Text("→")
                        .frame(width: 30, height: 40)
                        .font(.custom(BOLD, size: 24))
                        .foregroundColor(Color.black)
                    VStack {
                        Text("あがり")
                            .frame(width: 100, height: 5)
                            .font(.custom(REGULAR, size: 12))
                            .foregroundColor(Color.black)
                        Text("\(memberName[agari])")
                            .frame(height: 30)
                            .font(.custom(BOLD, size: 22))
                            .foregroundColor(Color.black)
                    }
                }
                HStack {
                    Text("翻")
                        .frame(width: block/2, height: 20, alignment: .center)
                        .font(.custom(REGULAR, size: 20))
                        .foregroundColor(Color.black)
                    Picker(selection: $han, label: Text("Picker"), content: {
                        ForEach(hanData, id:\.self) { value in
                            Text("\(value)")
                                .tag(value)
                        }
                    })
                    .frame(width: block)
                }
                
                HStack {
                    Text("符")
                        .frame(width: block/2, height: 20)
                        .font(.custom(REGULAR, size: 20))
                        .foregroundColor(Color.black)
                    Picker(selection: $fu, label: Text("Picker"), content: {
                        ForEach(fuData, id:\.self) { value in
                            Text("\(value)")
                                .tag(value)
                        }
                    })
                    .frame(width: block)
                }
                if calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.isOya(member: agari)).getError().isEmpty {
                    if isTsumo() {
                        Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.isOya(member: agari)).getTsumoScoreString(isOya: fieldDataModel.isOya(member: agari)))")
                            .frame(width: 300, height: 30)
                            .font(.custom(BOLD, size: 24))
                            .foregroundColor(Color.black)
                    } else {
                        Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.isOya(member: agari)).getScore())点")
                            .frame(width: block*2, height: 30)
                            .font(.custom(BOLD, size: 24))
                            .foregroundColor(Color.black)
                    }
                } else {
                    Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.isOya(member: agari)).getError())")
                        .frame(height: 30)
                        .font(.custom(BOLD, size: 18))
                        .foregroundColor(Color.error)
                }
                
                Button(action: {
                    calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: fieldDataModel.isOya(member: agari))
                    if !calcurator.getError().isEmpty {
                        return
                    }
                    
                    fieldDataModel.preSave()
                    fieldDataModel.executeScore(isTsumo: isTsumo(), score: calcurator.getScore(), agari: agari, harai: overlay)
                    
                    isInputMode = false
                    fieldDataModel.kyoutaku = 0
                    fieldDataModel.reachReset()
                    overlayReset()
                }) {
                    Text("点数計算")
                        .font(.custom(REGULAR, size: 18))
                        .frame(width: 250, height: 40)
                        .foregroundColor(Color(.white))
                        .background(Color("Background"))
                        .cornerRadius(20)
                        .padding()
                }
            }
            Button(action: {
                isInputMode = false
                overlayReset()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.custom(REGULAR, size: 35))
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Background"))
            }
            .offset(x: -width / 2 + 36, y: height > 800 ? -height * 0.32 / 2 + 32 : -height * 0.4 / 2 + 32)
        }
    }
    
    var ryukyokuModal: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height > 800 ? height * 0.38 : height * 0.47)
                .foregroundColor(Color.white)
                .cornerRadius(32)
            VStack {
                ForEach((Config.Member.TON...Config.Member.PEI), id:\.self) { i in
                    HStack {
                        //Spacer()
                        Text(memberName[i])
                            .frame(width: 100, height: 40)
                            .font(.custom(BOLD, size: 18))
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
                    
                    isRyukyokuMode = false
                }) {
                    Text("罰符精算")
                        .font(.custom(REGULAR, size: 18))
                        .frame(width: 250, height: 40)
                        .foregroundColor(Color(.white))
                        .background(Color("Background"))
                        .cornerRadius(20)
                        .padding()
                        //.shadow(radius: 8)
                }
            }
            Button(action: {
                isRyukyokuMode = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.custom(REGULAR, size: 35))
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Background"))
            }
            .offset(x: -width / 2 + 36, y: height > 800 ? -height * 0.38 / 2 + 32 : -height * 0.47 / 2 + 32)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Title")]), startPoint: .top, endPoint: .trailing)
                .ignoresSafeArea()      // フレームサイズをセーフエリア外まで広げる
            
            if isChoiced {
                Path { path in
                    path.move(to: start)        // 始点移動
                    path.addLine(to: end)   // 直線描画
                }
                .stroke(lineWidth: 10)
                .fill(Color.arrow)
                dragPoint
            }
            Group {
                VStack {
                    Spacer()
                    shaView
                    Spacer()
                    ZStack {
                        //Spacer()
                        peiView
                            .offset(x: -width * 0.3, y: 0)
                        //Spacer(minLength: 140)
                        nanView
                            .offset(x: width * 0.3, y: 0)
                        //Spacer()
                    }
                    
                    Spacer()
                    tonView
                    Spacer()
                }
            }
            
            VStack {
                Text("\(bakazeData[fieldDataModel.bakaze / 4])\(fieldDataModel.bakaze % 4 + 1)局")
                    .font(.custom(BOLD, size: 32))
                    .foregroundColor(Color.white)
                    .frame(height: 28)
                    .shadow(radius: 8)
                Text("\(fieldDataModel.honba)本場")
                    .font(.custom(BOLD, size: 20))
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                VStack {
                    Text("供託: \(fieldDataModel.kyoutaku)点")
                        .font(.custom(BOLD, size: 16))
                        .foregroundColor(Color.white)
                        .shadow(radius: 10)
                }
                Button(action: {
                    isRyukyokuMode = true
                }) {
                    Text("流局")
                        .font(.custom(BOLD, size: 16))
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
            
            VStack {
                Button(action: {
                    isAlert = true
                }) {
                    Image(systemName: "xmark")
                        .font(.custom(REGULAR, size: 18))
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
            .frame(width: width * 0.9, height: height * 0.9, alignment: .topLeading)
            
            VStack {
                Button(action: {
                    fieldDataModel.returnData()
                }) {
                    Image(systemName: "return")
                        .font(.custom(REGULAR, size: 18))
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
            .frame(width: width * 0.63, height: height * 0.9, alignment: .topLeading)
            
            Rectangle()
                .frame(width: width, height: height)
                .ignoresSafeArea()
                .foregroundColor(Color(white: 0, opacity: isInputMode || isRyukyokuMode ? 0.5 : 0))
                .animation(.default, value: isInputMode || isRyukyokuMode)
                .onTapGesture(perform: {
                    isInputMode = false
                    isRyukyokuMode = false
                    overlayReset()
                })
        
            calcurateModal
                .frame(width: width, height: height, alignment: .bottom)
                .offset(x: 0, y: isInputMode ? 0 : 500)
                .animation(.default, value: isInputMode)
            ryukyokuModal
                .frame(width: width, height: height, alignment: .bottom)
                .offset(x: 0, y: isRyukyokuMode ? 0 : 500)
                .animation(.default, value: isRyukyokuMode)
                
        }
        .opacity(self.opacity)
        .onAppear {
            withAnimation(.linear(duration: 0.3)) {
                // NOTE: opacityを変更する画面再描画に対してアニメーションを適用する
                self.opacity = 1.0
            }
        }
    }
    
    private func positionCheck() {
        if end.x < leftVert {
            overlay = Config.Member.PEI
        } else if end.x > rightVert {
            overlay = Config.Member.NAN
        } else if end.y < bottomHori {
            overlay = Config.Member.SHA
        } else if end.y > topHori {
            overlay = Config.Member.TON
        } else {
            overlay = -1
        }
        overlayPlayer = overlay
    }
    
    private func overlayReset() {
        overlay = -1
    }
    
    private func overlayCheck() {
        isChoiced = false
        
        if overlay != -1 {
            isInputMode = true
        } else {
            overlayReset()
        }
    }
    
    private func getOverlayName() -> String {
        return overlayPlayer != -1 ? (overlayPlayer != agari ? memberName[overlayPlayer] : "ツモ") : ""
    }
    
    private func isTsumo() -> Bool {
        return getOverlayName() == "ツモ"
    }
    
    private func resetTenpaiArray() {
        for i in Config.Member.TON...Config.Member.PEI {
            tenpaiArray[i] = "ノーテン"
        }
    }
}

private func getCardWidth(str: String) -> CGFloat {
    let min:CGFloat = 70
    let each:Int = 28
    
    return CGFloat(str.count * each) < min ? min : CGFloat(str.count * each)
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        BattleView(memberName: Binding.constant(["だいげん", "しょうさん", "いーそー", "いさんげ"]), isPresented: Binding.constant(true))
    }
}
