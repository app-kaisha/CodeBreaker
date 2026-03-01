//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 01/03/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct GameEditor: View {
    
    // MARK: - Data (Function) In
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Data Shared with me
    @Bindable var game: CodeBreaker
    
    // MARK: - Data owned by me
    @State private var showInvalidGameAlert = false
    
    // MARK: Action Function
    let onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .onSubmit {
                            done()
                        }
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        done()
                    }
                    .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                        Button("OK") {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("A game must have a name and more than one unique peg.")
                    }
                }
            }
        }
    }
    
    func done() {
        if game.isValid {
            onChoose()
            dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable let game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple])
    
    GameEditor(game: game) {
        
    }
    .onChange(of: game.name) {
        print("game name changed to \(game.name)")
    }
    .onChange(of: game.pegChoices) {
        print("game pegs changed to \(game.pegChoices)")
    }
}
