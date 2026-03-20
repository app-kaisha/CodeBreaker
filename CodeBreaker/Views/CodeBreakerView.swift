//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 21/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI


struct CodeBreakerView: View {
    
    // MARK: - Data In
    @Environment(\.scenePhase) var scenePhase
    // Access to scene size from app launch
    @Environment(\.sceneFrame) var sceneFrame
    
    // MARK: Data Shared with me
    let game: CodeBreaker
    
    // MARK: Data Owned by me
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                        
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                    
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView( code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches  {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            
            GeometryReader { geometry in
                if !game.isOver {
                    let offset = sceneFrame.maxY - geometry.frame(in: .global).minY
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        //.transition(.pegChooser)
                        .transition(.offset(x: 0, y: offset))
                        
                }
            }
            .aspectRatio(CGFloat(game.pegChoices.count), contentMode: .fit)
            .frame(maxHeight: 90)
            //.background(.yellow)
            
        }
        .gesture(pegChoosingDial)
        .trackElapsedTimeInGame(in: game)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: restart)
            }
            ToolbarItem {
                Button("Save", systemImage: "square.and.arrow.down") {
                    // Write JSON of this game out into documents directory
                    if let json = try? JSONEncoder().encode(game) {
                        let url = URL.documentsDirectory
                            .appendingPathComponent(game.name)
                            .appendingPathExtension("json")
                        try? json.write(to: url)
                    }
                }
            }
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .monospaced()
                    .lineLimit(1)
            }
            
        }
        .padding()
    }
    
    // Gesture
    var pegChoosingDial: some Gesture {
        RotateGesture()
            .onChanged { value in
                // cycle peg choice every 90 degrees of finger rotation on screen
                
                // TODO: protect for Nan cases
                let pegChoiceIndex = Int(abs(value.rotation.degrees) / 90) % game.pegChoices.count
                game.guess.pegs[selection] = game.pegChoices[pegChoiceIndex]
            }
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
        
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
            
        }
    }
    
}



extension CodeBreaker {
    convenience init(name: String = "Code Breaker", pegChoices: [Color]) {
        self.init(name: name, pegChoices: pegChoices.map { $0.hex })
    }
    
    var pegColourChoices: [Color] {
        get { pegChoices.map { Color(hex: $0) ?? .clear }}
        set { pegChoices = newValue.map { $0.hex }}
    }
}



//#Preview(traits: .modifier(SwiftDataPreview())) {
#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [.blue, .red, .orange])
    NavigationStack {
        CodeBreakerView(game: game)
        
    }
}
