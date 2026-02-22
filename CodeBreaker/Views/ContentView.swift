//
//  ContentView.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 21/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colours: [.red, .yellow, .green, .green])
            pegs(colours: [.blue, .yellow, .red, .green])
            pegs(colours: [.red, .blue, .blue, .yellow])
            
        }
        .padding()
    }
    
    func pegs(colours: Array<Color>) -> some View {
        HStack {
            ForEach(colours.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colours[index])
                
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    ContentView()
}
