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
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                    //.listRowSeparator(.hidden)
                    //.listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.yellow.gradient.opacity(0.5)).padding(5))
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs  in
                PegChooser(choices: pegs)
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
