//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: Data in
    let choices: [Peg]
    
    // MARK: Data Out Function
    var onChoose: ((Peg) -> Void)?

    // MARK: - Body
    var body: some View {
        
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
                
            }
        }
    }
}

#Preview {
    //PegChooser(choices: [Color.red, .blue, .green, .yellow].map(\.hex)) { peg in
    PegChooser(choices: [Color.red, .blue, .green, .yellow].map{ $0.hex }) { peg in
        print("chose \(peg)")
    }
    .padding()
}
