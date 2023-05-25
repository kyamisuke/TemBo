//
//  FieldState.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/03.
//

import Foundation
import SwiftUI

class FieldState: ObservableObject {
    @Published var isChoiced: Bool!
    @Published var start: CGPoint!
    @Published var end: CGPoint!
    @Published var overlay: Int!
    @Published var overlayPlayer: Int!
    @Published var isInputMode: Bool!
    @Published var isRyukyokuMode: Bool!
    var isMultiRonMode = false
    var preOverlay = -1

    init() {
        self.isChoiced = false
        self.start = CGPoint(x: 0, y: 0)
        self.end = CGPoint(x: 0, y: 0)
        self.overlay = -1
        self.overlayPlayer = -1
        self.isInputMode = false
        self.isRyukyokuMode = false
    }
    
    func positionCheck() {
        if end.x < Config.UI.LEFT_VERT {
            overlay = Config.Member.PEI
        } else if end.x > Config.UI.RIGHT_VERRT {
            overlay = Config.Member.NAN
        } else if end.y < Config.UI.BOTTOM_HORI {
            overlay = Config.Member.SHA
        } else if end.y > Config.UI.TOP_HORI {
            overlay = Config.Member.TON
        } else {
            overlay = -1
        }
        overlayPlayer = overlay
    }
    
    func overlayReset() {
        overlay = -1
    }
    
    func overlayCheck() {
        isChoiced = false
        
        if overlay != -1 {
            if isMultiRonMode {
                if preOverlay == overlay {
                    isInputMode = true
                } else {
                    overlayReset()
                }
            } else {
                isInputMode = true
                preOverlay = overlay
            }
        } else {
            overlayReset()
        }
    }
    
    func updateIsInputMode(value: Bool) {
        isInputMode = value
    }
    
    func updateIsRyukyokuMode(value: Bool) {
        isRyukyokuMode = value
    }
}
