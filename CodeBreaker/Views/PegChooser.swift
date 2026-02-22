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
    let onChoose: ((Peg) -> Void)?

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

//#Preview {
//    PegChooser(game: <#Binding<CodeBreaker>#>, selection: <#Binding<Int>#>)
//}
