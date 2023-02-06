//
//  ScoreDataModel.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/02.
//

import Foundation
import SwiftUI

class FieldDataModel:ObservableObject {
    @Published var scores: [Int]!
    @Published var oya: [Bool]!
    @Published var kyoutaku: Int!
    @Published var honba: Int!
    @Published var bakaze: Int!
    @Published var reachArray: [Bool]!
    @Published var agari: Int!
    
    var preScores = [25000, 25000, 25000, 25000]
    var preBakaze = 0
    var preOya = [true, false, false, false]
    var preHonba = 0
    var preKyoutaku = 0
    var preReach = [false, false, false, false]
    
    init() {
        scores = [25000, 25000, 25000, 25000]
        oya = [true, false, false, false]
        kyoutaku = 0
        honba = 0
        bakaze = 0
        reachArray = [false, false, false, false]
        agari = 0
    }
    
    func executeScore(isTsumo: Bool, score: Int, harai: Int) {
        if isTsumo {
            if oya[agari] {
                var all = score / 3
                all = CustomMath.ceil10decimal(num: all)
                for i in Config.Member.TON...Config.Member.PEI {
                    if i == agari {
                        scores[i] += all * 3 + kyoutaku + honba * 300
                    } else {
                        scores[i] -= all + honba * 100
                    }
                }
                renchan()
            } else {
                var oyaHarai = score / 2
                var koHarai = score / 4
                oyaHarai = CustomMath.ceil10decimal(num: oyaHarai)
                koHarai = CustomMath.ceil10decimal(num: koHarai)
                for i in Config.Member.TON...Config.Member.PEI {
                    if i == agari {
                        scores[i] += (oyaHarai + koHarai * 2) + kyoutaku + honba * 300
                    } else {
                        if oya[i] {
                            scores[i] -= oyaHarai + honba * 100
                        } else {
                            scores[i] -= koHarai + honba * 100
                        }
                    }
                }
                oyaNagare()
            }
        } else {
            scores[agari] += score + kyoutaku + honba * 300
            scores[harai] -= score + honba * 300
            
            if oya[agari] {
                renchan()
            } else {
                oyaNagare()
            }
        }
    }
    
    func executeeeRyukyoku(tenpaiCount: Int, tenpaiArray: [String]) {
        var isOyaKeizoku = false
        
        for i in Config.Member.TON...Config.Member.PEI {
            if tenpaiCount != 0 && tenpaiCount != 4 {
                if tenpaiArray[i] == "テンパイ" {
                    scores[i] += 3000 / tenpaiCount
                    if isOya(member: i) {
                        isOyaKeizoku = true
                    }
                } else {
                    scores[i] -= 3000 / (4 - tenpaiCount)
                }
            } else if tenpaiCount == 4 {
                isOyaKeizoku = true
            }
        }
        
        if isOyaKeizoku {
            renchan()
        } else {
            oyaNagare()
        }
        
        reachReset()
    }
    
     func renchan() {
        honba += 1
    }
    
     func oyaNagare() {
        honba = 0
        if bakaze < 7 {
            oya[bakaze % 4] = false
            bakaze += 1
            oya[bakaze % 4] = true
        }
    }
    
    func preSave() {
        preScores = scores
        preOya = oya
        preHonba = honba
        preReach = reachArray
        preBakaze = bakaze
        preKyoutaku = kyoutaku
    }
    
    func isOya(member: Int) -> Bool {
        return oya[member]
    }
    
    func agariIsOya() -> Bool {
        return oya[agari]
    }
    
    func isReach(member: Int) -> Bool {
        return reachArray[member]
    }
    
    func reachReset() {
        for i in 0..<4 {
            reachArray[i] = false
        }
    }
    
    func returnData() {
        scores = preScores
        oya = preOya
        honba = preHonba
        reachArray = preReach
        bakaze = preBakaze
        kyoutaku = preKyoutaku
    }
    
    func toggleReachState(member: Int) {
        reachArray[member].toggle()
        scores[member] += reachArray[member] ? -1000 : 1000
        kyoutaku += reachArray[member] ? 1000 : -1000
    }
    
    func updateAgari(agari: Int) {
        self.agari = agari
    }
}
