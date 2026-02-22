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
    
    var masterCode: Code = Code(kind: .master)
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.pegChoices = pegChoices
        masterCode.randomise(from: pegChoices)
        print(masterCode)
    }
    
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess = Code(kind: .guess)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        
        if let indexOfExistingInPegChoicesArray = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingInPegChoicesArray + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            // no peg chosen yet
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
        
    }
    
}

struct Code: Equatable {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomise(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        
        var pegsToMatch = otherCode.pegs
        
        var exactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
    
    //    func match(against otherCode: Code) -> [Match] {
    //        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
    //        var pegsToMatch = otherCode.pegs
    //        for index in pegs.indices.reversed() {
    //            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
    //                results[index] = .exact
    //                pegsToMatch.remove(at: index)
    //            }
    //        }
    //
    //        for index in pegs.indices {
    //            if results[index] != .exact {
    //                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
    //                    results[index] = .inexact
    //                    pegsToMatch.remove(at: matchIndex)
    //                }
    //            }
    //        }
    //
    //        return results
    //
    //    }
}
