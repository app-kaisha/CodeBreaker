//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 21/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI


struct CodeBreakerView: View {
    
    // MARK: Data Owned by me
    @State private var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])
    @State private var selection: Int = 0
    
    // MARK: - body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
                Text("0:03")
                    .font(.title)
            }
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                    
                }
                ForEach(game.attempts.indices.reversed(), id:\.self) { index in
                    CodeView( code: game.attempts[index]) {
                            if let matches = game.attempts[index].matches  {
                                MatchMarkers(matches: matches)
                            }
                        }
                }
            }
            if game.isOver {
                restartButton
            }
            
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
    }
    
    
    
    var restartButton: some View {
        Button("Restart") {
            game.resetGame()
        }
        .font(.system(size: 50))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .buttonStyle(.borderedProminent)
        .tint(Color.orange.opacity(0.7))
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
    
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
