//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 22/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import Foundation
import SwiftData

typealias Peg = String

@Model
class CodeBreaker{
    
    var name: String
    
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade)  var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade)  var _attempts: [Code] = []
    var pegChoices: [Peg]
    
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptedDate: Date = Date.now
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp }}
        set { _attempts = newValue }
        
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg]) {
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
        elapsedTime = 0
        
    }
    
    func attemptGuess() {
        // prohibit duplicating peg guesses, keeping identifiable attempts and so always in correct order
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        attempts.insert(attempt, at: 0)
        lastAttemptedDate = .now
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
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
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001 // as transient on start time will not trigger ui update but this will
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
}


