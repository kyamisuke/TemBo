//
//  Config.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/02.
//

import Foundation
import UIKit

class Config {
    class Member {
        static let TON = 0
        static let NAN = 1
        static let SHA = 2
        static let PEI = 3
        static let TSUMO = 4
        
        static let KAZE = ["東家（起家）", "南家", "西家", "北家"]
    }
    
    class System {
        static let HAN_DATA = [1,2,3,4,5,6,7,8,9,10,11,12,13]
        static let FU_DATA = [20,25,30,40,50,60,70,80,90,100,110]
    }
    
    class UI {
        static let BOLD = "ShipporiMincho-Bold"
        static let REGULAR = "ShipporiMincho-Regular"
        static let BAKAZE_DATA = ["東", "南"]
        static let MEMBER_TEXT_SIZE:CGFloat = 22
        static let SCORE_TEXT_SIZE:CGFloat = 18
        static let CARD_HEIGHT:CGFloat = 50
        static let OYA_MARK_HEIGHT:CGFloat = 32
        static let MIN_CARD_WIDTH:CGFloat = 70
        static let LENGTH_EACH_STRING:CGFloat = 28
        static let BLOCK:CGFloat = 80
        
        static let LEFT_VERT = UIScreen.main.bounds.width/3
        static let RIGHT_VERRT = UIScreen.main.bounds.width/3*2
        static let TOP_HORI = UIScreen.main.bounds.height/3*2
        static let BOTTOM_HORI = UIScreen.main.bounds.height/3
        static let TOUCH_OFFSET = CGPoint(x: 40, y: -15)
        
        static let WIDTH = UIScreen.main.bounds.width
        static let HEIGHT = UIScreen.main.bounds.height
        
        static let INPUT_WIDTH:CGFloat = 280
    }
    
    class Error {
        static let ERROR_MESSAGE_20FU_RON = "20符にロン上がりは存在しません"
        static let ERROR_MESSAGE_20OR25FU_1HAN = "20符、25符に1翻上がりは存在しません"
        static let ERROR_MESSAGE_25FU_2HAN = "25符に2翻ツモ上がりは存在しません"
    }
}
