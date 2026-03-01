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
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // edit game
                    deleteButtonForGame(for: game)
                }
                NavigationLink(value: game.masterCode.pegs) {
                    Text("Cheat")
                }
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
        .navigationDestination(for: [Peg].self) { pegs  in
            PegChooser(choices: pegs)
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // Edit list of games
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .onChange(of: gameToEdit) {
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil }) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(copyOfGameToEdit, at: 0)
                }
            }
        }
    }
    
    func deleteButtonForGame(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll(where: { $0 == game })
            }
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
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
