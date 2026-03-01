//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 01/03/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct PegChoicesChooser: View {
    
    // MARK: - Data shared with me
    @Binding var pegChoices: [Peg]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id:\.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    button("Peg Choice \(index+1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                pegChoices.append(.green)
            }
        }
    }
    
    func button (_ title: String, systemImage: String, color: Color? = nil, action: @escaping () -> Void) -> some View {
        
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage)
                    .tint(color)
            }
            
            Text(title)
        }

    }
    
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [.green, .orange]
    
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("Peg Choices =\(pegChoices)")
        }
}
