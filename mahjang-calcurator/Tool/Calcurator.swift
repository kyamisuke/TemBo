//
//  Calcurator.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/18.
//

import Foundation
import SwiftUI

class Calcurator  {
    let ERROR_MESSAGE_20FU_RON = "20符にロン上がりは存在しません"
    let ERROR_MESSAGE_20OR25FU_1HAN = "20符、25符に1翻上がりは存在しません"
    let ERROR_MESSAGE_25FU_2HAN = "25符に2翻ツモ上がりは存在しません"
    
    private var result: Result!
    
    init() {
        result = Result()
    }
    
    func calcurate(fu: Int, han: Int, isTsumo: Bool, isOya: Bool) -> Calcurator{
        let calcurator = Calcurator()
        if fu == 20 && !isTsumo {
            calcurator.result.error = ERROR_MESSAGE_20FU_RON
            return calcurator
        }
        
        if (fu == 20 || fu == 25) && han == 1 {
            calcurator.result.error = ERROR_MESSAGE_20OR25FU_1HAN
            return calcurator
        }
        
        if fu == 25 && han == 2 && isTsumo {
            calcurator.result.error = ERROR_MESSAGE_25FU_2HAN
            return calcurator
        }
        result.error = ""
        
        var score: Int!
        if isOya {
            score = fu * 6 * Int(pow(2.0, Double(han + 2)))
            score = ceil10decimal(num: score)
            
            if han == 4 && score > 12000 || han == 5 || fu >= 70 && han == 3 {
                score = 12000
            } else if han == 6 || han == 7 {
                score = 18000
            } else if 8 <= han && han <= 10 {
                score = 24000
            } else if han == 11 || han == 12 {
                score = 36000
            } else if han >= 13 {
                score = 48000
            }
            
            calcurator.result.score = score
        } else {
            score = fu * 4 * Int(pow(2.0, Double(han + 2)))
            score = Int(ceil(Double(Double(score) / 100.0)) * 100.0)

            if han == 4 && score > 8000 || han == 5 || fu >= 70 && han == 3 {
                score = 8000
            } else if han == 6 || han == 7 {
                score = 12000
            } else if 8 <= han && han <= 10 {
                score = 16000
            } else if han == 11 || han == 12 {
                score = 24000
            } else if han >= 13 {
                score = 32000
            }

            calcurator.result.score = score
        }
        
        return calcurator
    }
    
    func getScore() -> Int {
        return result.score
    }
    
    func getTsumoScoreString(isOya: Bool) -> String {
        if isOya {
            return "\(ceil10decimal(num: result.score / 3))点オール"
        }
        
        return "\(ceil10decimal(num: result.score / 2))点 - \(ceil10decimal(num: result.score / 4))点"
    }
    
    func getError() -> String {
        return result.error
    }
    
    func ceil10decimal(num:Int) -> Int {
        return Int(ceil(Double(Double(num) / 100.0)) * 100.0)
    }
}

struct Result {
    var score: Int = 0
    var error: String = ""
}
