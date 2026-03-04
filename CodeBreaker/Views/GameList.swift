//
//  GameList.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 01/03/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData

struct GameList: View {
    
    //MARK: Data in
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data shared with me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    // MARK: Data owned by me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        
        let lowercaseSearch = search.lowercased()
        let capitalisedSearch = search.capitalized
        let upperCaseSearch = search.uppercased()
        let predicate = #Predicate<CodeBreaker> { game in
            search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalisedSearch) || game.name.contains(upperCaseSearch)
        }
        
        switch sortBy {
        case .name:
            _games =  Query(filter: predicate, sort: \CodeBreaker.name, order: .reverse)
        case .recent:
            _games =  Query(filter: predicate, sort: \CodeBreaker.lastAttemptedDate, order: .forward)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            }
        }
    }
    
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
                .swipeActions(edge: .leading) {
                    editButton(for: game) // edit game
                        .tint(.accentColor)
                }
                NavigationLink(value: game.masterCode.pegs) {
                    Text("Cheat")
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
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
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool> {
            // Get
            gameToEdit != nil
        } set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        }
        
    }
    
    func deleteButtonForGame(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    func addSampleGames() {
        
        //        let fetchDescriptor = FetchDescriptor<CodeBreaker>(
        //            predicate: #Predicate { game in return true }
        //        )
        // does same as is Games.isempty
        //        let fetchDescriptor = FetchDescriptor<CodeBreaker>(
        //            predicate: .true,
        //            sortBy: [.init(\.name)]
        //        )
        // sortBy: [SortDescriptor<CodeBreaker>.init(\.name)]
        
        // but as true is the default can be simply:
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green,. yellow]))
            modelContext.insert(CodeBreaker(name: "Earth Tones",pegChoices: [.orange, .brown, .black,. yellow, .green]))
            modelContext.insert(CodeBreaker(name: "Undersea",pegChoices: [.blue, .indigo,. cyan]))
        }
        
        
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    
    NavigationStack {
        GameList(selection: $selection)
    }
}
