//
//  FieldDataViewModel.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2023/02/02.
//

import Foundation
import SwiftUI

class FieldDataViewModel:ObservableObject {
    @ObservedObject var fieldDtaModel = FieldDataModel()
    
    func executeScore(isTsumo: Bool, score: Int, agari: Int, harai: Int) {
        fieldDtaModel.executeScore(isTsumo: isTsumo, score: score, agari: agari, harai: harai)
    }
    
    func renchan() {
        fieldDtaModel.renchan()
    }
    
    func oyaNagare() {
        fieldDtaModel.oyaNagare()
    }
    
    func preSave() {
        fieldDtaModel.preSave()
    }
    
    func isOya(member: Int) -> Bool {
        return fieldDtaModel.isOya(member: member)
    }
    
    func isReach(member: Int) -> Bool {
        return fieldDtaModel.isReach(member: member)
    }
    
    func reachReset() {
        fieldDtaModel.reachReset()
    }
    
    func returnData() {
        fieldDtaModel.returnData()
    }
}
