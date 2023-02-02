//
//  BattleView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/18.
//

import SwiftUI

struct BattleView: View {
    let TON = 0
    let NAN = 1
    let SHA = 2
    let PEI = 3
    let TSUMO = 4
    @Binding var memberName: [String]
    
    let hanData = [1,2,3,4,5,6,7,8,9,10,11,12,13]
    let fuData = [20,25,30,40,50,60,70,80,90,100,110]
    let tenpaiData = ["ノーテン", "テンパイ"]
    let bakazeData = ["東", "南"]
    @State private var scoreArray = [25000, 25000, 25000, 25000]
    @State private var preScore = [25000, 25000, 25000, 25000]
    @State private var reachArray = [false, false, false, false]
    @State private var preReach = [false, false, false, false]
    @State private var tenpaiArray = ["ノーテン", "ノーテン", "ノーテン", "ノーテン"]
    @State private var overlay = -1
    @State private var overlayPlayer = -1
    @State private var agari = 0
    @State private var isInputMode = false
    @State private var isRyukyokuMode = false
    @State private var bakaze = 0
    @State private var preBakaze = 0
    @State private var oya = 0
    @State private var preOya = 0
    @State private var honba = 0
    @State private var preHonba = 0
    @State private var kyoutaku = 0
    @State private var preKyoutaku = 0
    
    @State private var isChoiced = false
    @State private var start = CGPoint(x: 0, y: 0)
    @State private var end = CGPoint(x: 0, y: 0)
    @State var han:Int = 1
    @State var fu:Int = 30
    
    @State var isDirectlyInput = false
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
    @State private var calcurator: Calcurator = Calcurator()
    private let BOLD = "ShipporiMincho-Bold"
    private let REGULAR = "ShipporiMincho-Regular"
    private let MEMBER_TEXT_SIZE:CGFloat = 22
    private let SCORE_TEXT_SIZE:CGFloat = 18
    private let CARD_HEIGHT:CGFloat = 50
    
    var shaView: some View {
        Group {
            VStack {
                Image(oya == SHA ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: oya)
                Text(memberName[SHA])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[SHA]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(reachArray[SHA] ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: -8, y: -8)
                    .onTapGesture(perform: {
                        reachArray[SHA].toggle()
                        scoreArray[SHA] += reachArray[SHA] ? -1000 : 1000
                        kyoutaku += reachArray[SHA] ? 1000 : -1000
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = SHA
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == SHA ? 1.2 : 1)
                    .animation(.default, value: overlay == SHA)
                    .animation(.easeOut(duration: 0.2), value: reachArray[SHA])
                Text("\(scoreArray[SHA])")
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
                Image(oya == PEI ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: oya)
                Text(memberName[PEI])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[PEI]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(reachArray[PEI] ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: 8, y: -8)
                    .onTapGesture(perform: {
                        reachArray[PEI].toggle()
                        scoreArray[PEI] += reachArray[PEI] ? -1000 : 1000
                        kyoutaku += reachArray[PEI] ? 1000 : -1000
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = PEI
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == PEI ? 1.2 : 1)
                    .animation(.default, value: overlay == PEI)
                    .animation(.easeOut(duration: 0.2), value: reachArray[PEI])
                Text("\(scoreArray[PEI])")
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
                Image(oya == NAN ? "OyaMark" : "NoOyaMark")
                    .frame(height: imageHeight)
                    .animation(.default, value: oya)
                Text(memberName[NAN])
                    .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                    .frame(width: getCardWidth(str: memberName[NAN]), height: CARD_HEIGHT)
                    .foregroundColor(Color.textBlack)
                    .background(reachArray[NAN] ? Color.reach : .white)
                    .cornerRadius(8)
                    .shadow(radius: 8, x: -8, y: 8)
                    .onTapGesture(perform: {
                        reachArray[NAN].toggle()
                        scoreArray[NAN] += reachArray[NAN] ? -1000 : 1000
                        kyoutaku += reachArray[NAN] ? 1000 : -1000
                    })
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                isChoiced = true
                                start = value.startLocation + offset
                                end = value.location + offset
                                agari = NAN
                                positionCheck()
                            }
                            .onEnded{ value in
                                overlayCheck()
                            }
                    )
                    .scaleEffect(overlay == NAN ? 1.2 : 1)
                    .animation(.default, value: overlay == NAN)
                    .animation(.easeOut(duration: 0.2), value: reachArray[NAN])
                Text("\(scoreArray[NAN])")
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
                    Image(oya == TON ? "OyaMark" : "NoOyaMark")
                        .frame(height: imageHeight)
                        .animation(.default, value: oya)
                    Text(memberName[TON])
                        .font(.custom(BOLD, size: MEMBER_TEXT_SIZE))
                        .frame(width: getCardWidth(str: memberName[TON]), height: CARD_HEIGHT)
                        .foregroundColor(Color.textBlack)
                        .background(reachArray[TON] ? Color.reach : .white)
                        .cornerRadius(8)
                        .shadow(radius: 8, x: 8, y: 8)
                        .onTapGesture(perform: {
                            reachArray[TON].toggle()
                            scoreArray[TON] += reachArray[TON] ? -1000 : 1000
                            kyoutaku += reachArray[TON] ? 1000 : -1000
                        })
                        .gesture(
                            DragGesture(coordinateSpace: .global)
                                .onChanged{ value in
                                    isChoiced = true
                                    start = value.startLocation + offset
                                    end = value.location + offset
                                    agari = TON
                                    positionCheck()
                                }
                                .onEnded{ value in
                                    overlayCheck()
                                }
                        )
                        .scaleEffect(overlay == TON ? 1.2 : 1)
                        .animation(.default, value: overlay == TON)
                        .animation(.easeOut(duration: 0.2), value: reachArray[TON])
                    Text("\(scoreArray[TON])")
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
                if calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari).getError().isEmpty {
                    if isTsumo() {
                        Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari).getTsumoScoreString(isOya: oya == agari))")
                            .frame(width: 300, height: 30)
                            .font(.custom(BOLD, size: 24))
                            .foregroundColor(Color.black)
                    } else {
                        Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari).getScore())点")
                            .frame(width: block*2, height: 30)
                            .font(.custom(BOLD, size: 24))
                            .foregroundColor(Color.black)
                    }
                } else {
                    Text("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari).getError())")
                        .frame(height: 30)
                        .font(.custom(BOLD, size: 18))
                        .foregroundColor(Color.error)
                }
                
                Button(action: {
                    print("\(calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari).getScore())")
                    calcurator = calcurator.calcurate(fu: fu, han: han, isTsumo: isTsumo(), isOya: oya == agari)
                    if !calcurator.getError().isEmpty {
                        return
                    }
                    
                    preSave()
                    if isDirectlyInput {
                        scoreArray[agari] += Int(directScore)! + kyoutaku + honba * 300
                        scoreArray[overlay] -= Int(directScore)! + honba * 300
                    } else {
                        if isTsumo() {
                            let score = calcurator.getScore()
                            if agari == oya {
                                var all = score / 3
                                all = calcurator.ceil10decimal(num: all)
                                for i in TON...PEI {
                                    if i == agari {
                                        scoreArray[i] += all * 3 + kyoutaku + honba * 300
                                    } else {
                                        scoreArray[i] -= all + honba * 100
                                    }
                                }
                                renchan()
                            } else {
                                var oyaHarai = score / 2
                                var koHarai = score / 4
                                oyaHarai = calcurator.ceil10decimal(num: oyaHarai)
                                koHarai = calcurator.ceil10decimal(num: koHarai)
                                for i in TON...PEI {
                                    if i == agari {
                                        scoreArray[i] += (oyaHarai + koHarai * 2) + kyoutaku + honba * 300
                                    } else {
                                        if i == oya {
                                            scoreArray[i] -= oyaHarai + honba * 100
                                        } else {
                                            scoreArray[i] -= koHarai + honba * 100
                                        }
                                    }
                                }
                                oyaNagare()
                            }
                        } else {
                            scoreArray[agari] += calcurator.getScore() + kyoutaku + honba * 300
                            scoreArray[overlay] -= calcurator.getScore() + honba * 300
                            
                            if agari == oya {
                                renchan()
                            } else {
                                oyaNagare()
                            }
                        }
                    }
                    isInputMode = false
                    kyoutaku = 0
                    reachReset()
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
                ForEach((TON...PEI), id:\.self) { i in
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
                    preSave()
                    let tenpaiCount = tenpaiArray.filter({ $0 == "テンパイ"}).count
                    var isOyaKeizoku = false
                    
                    for i in TON...PEI {
                        if tenpaiCount != 0 && tenpaiCount != 4 {
                            if tenpaiArray[i] == "テンパイ" {
                                scoreArray[i] += 3000 / tenpaiCount
                                if oya == i {
                                    isOyaKeizoku = true
                                }
                            } else {
                                scoreArray[i] -= 3000 / (4 - tenpaiCount)
                            }
                        }
                        tenpaiArray[i] = "ノーテン"
                    }
                    
                    if isOyaKeizoku {
                        renchan()
                    } else {
                        ryukyoku()
                    }
                    
                    reachReset()
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
                Text("\(bakazeData[bakaze / 4])\(oya + 1)局")
                    .font(.custom(BOLD, size: 32))
                    .foregroundColor(Color.white)
                    .frame(height: 28)
                    .shadow(radius: 8)
                Text("\(honba)本場")
                    .font(.custom(BOLD, size: 20))
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                VStack {
                    Text("供託: \(kyoutaku)点")
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
                    returnData()
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
    
    private func renchan() {
        honba += 1
    }
    
    private func ryukyoku() {
        honba += 1
        if bakaze < 7 {
            bakaze += 1
            oya = (oya + 1) % 4
        }
    }
    
    private func oyaNagare() {
        honba = 0
        if bakaze < 7 {
            bakaze += 1
            oya = (oya + 1) % 4
        }
    }
    
    private func positionCheck() {
        if end.x < leftVert {
            overlay = PEI
        } else if end.x > rightVert {
            overlay = NAN
        } else if end.y < bottomHori {
            overlay = SHA
        } else if end.y > topHori {
            overlay = TON
        } else {
            overlay = -1
        }
        overlayPlayer = overlay
    }
    
    private func overlayReset() {
        overlay = -1
    }
    
    private func reachReset() {
        for i in 0..<4 {
            reachArray[i] = false
        }
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
    
    private func preSave() {
        preScore = scoreArray
        preOya = oya
        preHonba = honba
        preReach = reachArray
        preBakaze = bakaze
        preKyoutaku = kyoutaku
    }
    
    private func returnData() {
        scoreArray = preScore
        oya = preOya
        honba = preHonba
        reachArray = preReach
        bakaze = preBakaze
        kyoutaku = preKyoutaku
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
