//
//  WordChecker.swift
//  InfWorld
//
//  Created by Brody on 10/16/24.
//

import Foundation
import SwiftUI

struct WordChecker{
    @State var userGuess = ""
    @State var errorTitle = ""
    @State var errorMessage = ""
    @State var showingError = false
    @State private var validWordsSet: Set<String> = []
    @State var answer = ""
    


    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func charCheck(word: String) ->Bool{
        if word.count == 5 {
            return true
        } else{
            return false
        }
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    func addNewWord() {
        let answer = userGuess.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "Word doesn't exist!")
            return
        }
        guard charCheck(word:answer) else{
            wordError(title: "Word not long enough", message: "The word must be 5 characters!")
            return
        }
        
        
    }
}


