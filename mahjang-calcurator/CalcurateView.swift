//
//  ContentView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/16.
//

import SwiftUI

struct CalcurateView: View {
    let hanData = [1,2,3,4,5,6,7,8,9,10,11,12,13]
    let fuData = [20,25,30,40,50,60,70,80,90,100,110]
    let agariData = ["ロン", "ツモ"]
    let statusData = ["親", "子"]
    let honbaData = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    let ERROR_MESSAGE_20FU_RON = "20符にロン上がりは\n存在しません"
    let ERROR_MESSAGE_20OR25FU_1HAN = "20符、25符に1翻上がりは\n存在しません"
    let ERROR_MESSAGE_25FU_2HAN = "25符に2翻ツモ上がりは\n存在しません"
    let errorSize = 32
    let block:CGFloat = 120.0
    let sepHeight:CGFloat = 2
    
    @State var hanSelection:Int = 1
    @State var fuSelection:Int = 30
    @State var agariSelection:String = "ロン"
    @State var statusSelection:String = "親"
    @State var honbaSelection:Int = 0
    @State var result:String = ""
    @State var resultSize:Int = 52
    @State var kyoutaku:String = "0"
    @State var circleCenter = CGPoint.zero
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor(Color("Picker-Deselected")), .font : UIFont.systemFont(ofSize: 16)], for: .normal
        )
        
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor(Color("Picker-Selected")), .font : UIFont.systemFont(ofSize: 16)], for: .selected
        )
    }

    var body: some View {
        let separator:CGFloat = block * 2 + 50
        ZStack {
            Image("mahjang")
                .resizable()
                .scaledToFill()
                .offset(x:-20, y:0)
                .ignoresSafeArea()
                //.scaledToFit()      // 縦横比を維持しながらフレームに収める
                //.frame(width: 300, height: 150)
            
            
            VStack {
                //Spacer()
                Text("麻雀点数計算")
                    .font(.custom("Corporate-Logo-Bold", size: 40))
                    .frame(width: 450, height: 64)
                    .foregroundColor(Color.white)
                    .background(Color("Title"))
                
                Spacer()
                Group {
                    HStack {
                        Text("翻")
                            .frame(width: block, height: 40, alignment: .center)
                            .font(.custom("Corporate-Logo-Medium", size: 24))
                            .foregroundColor(Color.white)
                        Picker(selection: $hanSelection, label: Text("Picker"), content: {
                            ForEach(hanData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .frame(width: block)
                    }
                    Rectangle()
                        .foregroundColor(Color("Title"))
                        .frame(width: separator, height: sepHeight)
                        //.padding(5)
                    HStack {
                        Text("符")
                            .frame(width: block, height: 40)
                            .font(.custom("Corporate-Logo-Medium", size: 24))
                            .foregroundColor(Color.white)
                        Picker(selection: $fuSelection, label: Text("Picker"), content: {
                            ForEach(fuData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .frame(width: block)
                    }
                    Rectangle()
                        .foregroundColor(Color("Title"))
                        .frame(width: separator, height: sepHeight)
                        //.padding(5)
                    HStack {
                        Text("和がり方")
                            .frame(width: block, height: 40)
                            .font(.custom("Corporate-Logo-Medium", size: 24))
                            .foregroundColor(Color.white)
                        Picker(selection: $agariSelection, label: Text("Picker"), content: {
                            ForEach(agariData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
                        .frame(width: block)
                    }
                    Rectangle()
                        .foregroundColor(Color("Title"))
                        .frame(width: separator, height: sepHeight)
                        //.padding(5)
                    HStack {
                        Text("親か子か")
                            .frame(width: block, height: 40)
                            .font(.custom("Corporate-Logo-Medium", size: 24))
                            .foregroundColor(Color.white)
                        Picker(selection: $statusSelection, label: Text("Picker"), content: {
                            ForEach(statusData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
                        .frame(width: block)
                    }
                    Rectangle()
                        .foregroundColor(Color("Title"))
                        .frame(width: separator, height: sepHeight)
                        //.padding(5)
                    HStack {
                        Text("本場")
                            .frame(width: block, height: 40)
                            .font(.custom("Corporate-Logo-Medium", size: 24))
                            .foregroundColor(Color.white)
                        Picker(selection: $honbaSelection, label: Text("Picker"), content: {
                            ForEach(honbaData, id:\.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        })
                        .frame(width: block)
                    }
                }
                Spacer()
                Button(action: {
                    resultSize = 52
                    if fuSelection == 20 && agariSelection == "ロン" {
                        result = ERROR_MESSAGE_20FU_RON
                        resultSize = errorSize
                        return
                    }
                    
                    if (fuSelection == 20 || fuSelection == 25) && hanSelection == 1 {
                        result = ERROR_MESSAGE_20OR25FU_1HAN
                        resultSize = errorSize
                        return
                    }
                    
                    if fuSelection == 25 && hanSelection == 2 && agariSelection == "ツモ" {
                        result = ERROR_MESSAGE_25FU_2HAN
                        resultSize = errorSize
                        return
                    }
                    
                    var score: Int!
                    switch(statusSelection) {
                    case "親":
                        score = fuSelection * 6 * Int(pow(2.0, Double(hanSelection + 2)))
                        score = ceil10decimal(num: score)
                        
                        if hanSelection == 4 && score > 12000 || hanSelection == 5 {
                            score = 12000
                        } else if hanSelection == 6 || hanSelection == 7 {
                            score = 18000
                        } else if 8 <= hanSelection && hanSelection <= 10 {
                            score = 24000
                        } else if hanSelection == 11 || hanSelection == 12 {
                            score = 36000
                        } else if hanSelection >= 13 {
                            score = 48000
                        }
                        
                        result = String(score + honbaSelection * 300)
                        
                        if agariSelection == "ツモ" {
                            var all: Int!
                            all = score / 3
                            all = ceil10decimal(num: all)
                            all += honbaSelection * 100
                            result = "\(all!)オール"
                        }
                        break
                        
                    case "子":
                        score = fuSelection * 4 * Int(pow(2.0, Double(hanSelection + 2)))
                        score = Int(ceil(Double(Double(score) / 100.0)) * 100.0)
                        
                        if hanSelection == 4 && score > 8000 || hanSelection == 5 {
                            score = 8000
                        } else if hanSelection == 6 || hanSelection == 7 {
                            score = 12000
                        } else if 8 <= hanSelection && hanSelection <= 10 {
                            score = 16000
                        } else if hanSelection == 11 || hanSelection == 12 {
                            score = 24000
                        } else if hanSelection >= 13 {
                            score = 32000
                        }
                        
                        result = String(score + honbaSelection * 300)
                        if agariSelection == "ツモ" {
                            var oya: Int!
                            var ko: Int!
                            oya = score / 2
                            oya = ceil10decimal(num: oya)
                            oya += honbaSelection * 100
                            ko = score / 4
                            ko = ceil10decimal(num: ko)
                            ko += honbaSelection * 100
                            result = "\(ko!)-\(oya!)"
                        }
                        break
                        
                    default:
                        print("和がり方: 不明な値")
                        break
                    }
                }) {
                    Text("点数計算")
                        .font(.custom("Corporate-Logo-Medium", size: 24))
                        .frame(width: 160, height: 48)
                        .foregroundColor(Color("Background"))
                        .background(Color(.white))
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color("Background"), lineWidth: 1.0)
                        )
                        .shadow(radius: 8)
                }
                
                Text(result)
                    .font(.custom("Corporate-Logo-Bold", size: CGFloat(resultSize)))
                    .multilineTextAlignment(.center)
                    .frame(width: 380)
                    .foregroundColor(Color(CGColor(gray: 20/255, alpha: 0.65)))
                    .padding(16)
                Spacer()
            }
            //.padding(50)

        }
    }
}

struct CalcurateView_Previews: PreviewProvider {
    static var previews: some View {
        CalcurateView()
    }
}

func ceil10decimal(num:Int) -> Int {
    return Int(ceil(Double(Double(num) / 100.0)) * 100.0)
}
