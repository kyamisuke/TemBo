//
//  CGPointExtension.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/01/18.
//

import SwiftUI

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
