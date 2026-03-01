//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

typealias Peg = Color

@Observable
class CodeBreaker{
    
    var name: String
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    var pegChoices: [Peg]
    
    var startTime: Date = .now
    var endTime: Date?
    
    init(name: String = "Code Breaker", pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.pegChoices = pegChoices
        self.name = name
        masterCode.randomise(from: pegChoices)
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func restart() {
        masterCode.randomise(from: pegChoices)
        masterCode.kind = .master(isHidden: true)
        guess = Code(kind: .guess)
        attempts = []
        startTime = .now
        endTime = nil
        
    }
    
    func attemptGuess() {
        // prohibit duplicating peg guesses, keeping identifiable attempts and so always in correct order
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        
        if let indexOfExistingInPegChoicesArray = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingInPegChoicesArray + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            // no peg chosen yet
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
        
    }
    
}

extension CodeBreaker: Identifiable, Hashable  {
    
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


