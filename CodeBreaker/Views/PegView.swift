//
//  PegView.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct PegView: View {
    
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: Peg(.red))
        .padding()
}
