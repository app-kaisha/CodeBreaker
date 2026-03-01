//
//  GameList.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 01/03/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct GameList: View {
    
    // MARK: Data shared with me
    @Binding var selection: CodeBreaker?
    
    // MARK: Data owned by me
    @State private var games: [CodeBreaker] = []

    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    deleteButtonForGame(for: game)
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
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        
//            .navigationDestination(for: CodeBreaker.self) { game in
//                CodeBreakerView(game: game)
//                    .navigationTitle(game.name)
//                    .navigationBarTitleDisplayMode(.inline)
//            }
        .navigationDestination(for: [Peg].self) { pegs  in
            PegChooser(choices: pegs)
        }
        .listStyle(.plain)
        .toolbar {
            withAnimation {
                Button("Add Game", systemImage: "plus") {
                    let newGame = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
                    games.append(newGame)
                }
            }
            EditButton()
        }
        .onAppear {
            addSampleGames()
        }
        

    }
    
    func deleteButtonForGame(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll(where: { $0 == game })
            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green,. yellow]))
            games.append(CodeBreaker(name: "Earth Tones",pegChoices: [.orange, .brown, .black,. yellow, .green]))
            games.append(CodeBreaker(name: "Undersea",pegChoices: [.blue, .indigo,. cyan]))
            
            selection = games.first
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    
    NavigationStack {
        GameList(selection: $selection)
    }
}
