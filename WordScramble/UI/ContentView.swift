//
//  ContentView.swift
//  WordScramble
//
//  Created by Zaid Neurothrone on 2022-10-03.
//

import SwiftUI

struct WordScoring: Identifiable {
  let id = UUID().uuidString
  
  let word: String
  var score: Int
  
  mutating func increment() {
    score += 1
  }
}

struct ContentView: View {
  @FocusState private var isTextFieldFocused: Bool
  
  @State private var usedWords: [String] = []
  @State private var rootWord = ""
  @State private var newWord = ""
  
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var isErrorAlertPresented = false
  
  @State private var wordScorings: [WordScoring] = []
  @State private var currentIndex: Int = .zero
  
  private let words: [String]
  
  init() {
    words = Self.loadWords()
    let startRootWord = getRandomWord()
    _rootWord = State(initialValue: startRootWord)
  }
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle(rootWord)
        .task {
          addWordScore()
        }
        .alert(errorTitle, isPresented: $isErrorAlertPresented) {
          Button("OK", role: .cancel) { isTextFieldFocused = true }
        } message: {
          Text(errorMessage)
        }
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { isTextFieldFocused = false }
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              restart()
            } label: {
              Text("Restart")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
          }
        }
    }
  }
  
  var content: some View {
    List {
      Section {
        TextField("Enter your word", text: $newWord)
          .focused($isTextFieldFocused)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.never)
          .submitLabel(.next)
      }
      .onSubmit(addNewWord)
      
      Section {
        ForEach(usedWords, id: \.self) { word in
          HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
          }
        }
      }
      
      ScoreBoardView(wordScorings: wordScorings)
    }
  }
}

extension ContentView {
  private func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }
  
  private func addNewWord() {
    let userWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    guard userWord.count > 0 else { return }
    
    guard isOriginal(word: userWord) else {
      wordError(title: "Word used already", message: "Be more original")
      return
    }
    
    guard isPossible(word: userWord) else {
      wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
      return
    }
    
    guard isReal(word: userWord) else {
      wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
      return
    }
    
    guard isNotRootWord(word: userWord) else {
      wordError(title: "Root word detected", message: "You can't use the root word.")
      return
    }
    
    guard isNotTooShort(word: userWord) else {
      wordError(title: "Too short", message: "Words shorter than three letters are not allowed.")
      return
    }
    
    withAnimation(.easeInOut) {
      usedWords.insert(userWord, at: .zero)
    }
    
    let scoreMultiplier = usedWords.count
    let pointsPerLetter = newWord.count
    wordScorings[currentIndex].score += (scoreMultiplier * pointsPerLetter)
    
    newWord = ""
    isTextFieldFocused = true
  }
  
  private func isPossible(word: String) -> Bool {
    var tempWord = rootWord
    
    for letter in word {
      if let pos = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: pos)
      } else {
        return false
      }
    }
    
    return true
  }
  
  private func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  private func isNotRootWord(word: String) -> Bool {
    rootWord != word
  }
  
  private func isNotTooShort(word: String) -> Bool {
    word.count >= 3
  }
  
  private func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    isErrorAlertPresented.toggle()
  }
  
  private func addWordScore() {
    let wordScore: WordScoring = .init(word: rootWord, score: .zero)
    wordScorings.insert(wordScore, at: .zero)
  }
  
  private func restart() {
    usedWords = []
    rootWord = getRandomWord()
    addWordScore()
    newWord = ""
    isTextFieldFocused = true
  }
  
  private func getRandomWord() -> String {
    words.randomElement() ?? "unknown"
  }
  
  static private func loadWords() -> [String] {
    guard let fileUrl = Bundle.main.url(forResource: "words", withExtension: "txt")
    else { fatalError("Failed to load file `start.txt` from bundle.") }
    
    guard let fileContents = try? String(contentsOf:  fileUrl)
    else { return [] }
    
    return fileContents.components(separatedBy: "\n")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
