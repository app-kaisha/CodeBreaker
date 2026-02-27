//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 27/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct GameChooser: View {
    
    // MARK: Data owned by me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List($games, id:\.pegChoices, editActions: [.delete, .move]) { $game in
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameSummary(game: game)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.yellow.gradient.opacity(0.5)).padding(5))
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green,. yellow]))
            games.append(CodeBreaker(name: "Earth Tones",pegChoices: [.orange, .brown, .black,. yellow, .green]))
            games.append(CodeBreaker(name: "Undersea",pegChoices: [.blue, .indigo,. cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
