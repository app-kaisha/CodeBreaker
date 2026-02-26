//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUICore

typealias Peg = Color

struct CodeBreaker {
    
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.pegChoices = pegChoices
        masterCode.randomise(from: pegChoices)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func restart() {
        masterCode.randomise(from: pegChoices)
        masterCode.kind = .master(isHidden: true)
        guess = Code(kind: .guess)
        attempts = []
        
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
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


