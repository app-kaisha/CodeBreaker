//
//  CodeView.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: Data Shared with me
    @Binding var selection: Int
    
    // MARK: - Body
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Selection.colour)
                    }
                }
                .overlay {
                    Selection.shape
                        .foregroundStyle(code.isHidden ? Color.gray : Color.clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                    
                }
            
        }
    }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let colour = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}

#Preview {
    CodeView(code: Code(kind: .guess), selection: .constant(1))
}
