//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    
    // MARK: Data In
    let matches: [Match]
    
    
    // MARK: - body
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
    }
    
    @ViewBuilder
    func matchMarker(peg: Int) -> some View {
        
        let exactCount: Int = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }
        
        Circle()
            .fill(exactCount > peg ? .black : .clear)
            .strokeBorder(foundCount > peg ? Color.primary : .clear, lineWidth: 3)
            .aspectRatio(1, contentMode: .fit)
    }
    
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}
