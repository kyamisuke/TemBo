//
//  ReArrangeAnimationView.swift
//  mahjang-calcurator
//
//  Created by 村上航輔 on 2024/04/29.
//

import SwiftUI

struct ReArrangeAnimationView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(red: 0, green: 0, blue: 0, opacity: 0.2))
            
            VStack {
                Rectangle()
                    .foregroundStyle(Color(.white))
                    .frame(width: 180, height: 60)
                    .cornerRadius(8)
                Rectangle()
                    .foregroundStyle(Color(.gray))
                    .frame(width: 180, height: 60)
                    .cornerRadius(8)
                Rectangle()
                    .foregroundStyle(Color(.gray))
                    .frame(width: 180, height: 60)
                    .cornerRadius(8)
                Rectangle()
                    .foregroundStyle(Color(.gray))
                    .frame(width: 180, height: 60)
                    .cornerRadius(8)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ReArrangeAnimationView()
}
