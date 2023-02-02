//
//  CustomMath.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/02.
//

import Foundation

class CustomMath {
    static func ceil10decimal(num:Int) -> Int {
        return Int(ceil(Double(Double(num) / 100.0)) * 100.0)
    }
}
