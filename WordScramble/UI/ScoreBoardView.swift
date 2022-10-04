//
//  ScoreBoardView.swift
//  WordScramble
//
//  Created by Zaid Neurothrone on 2022-10-04.
//

import SwiftUI

struct ScoreBoardView: View {
  let wordScorings: [WordScoring]
  
  var body: some View {
    Section {
      if wordScorings.isEmpty {
        Text("No score yet...")
      } else {
        ForEach(wordScorings) { wordScore in
          HStack {
            Image(systemName: "\(wordScore.word.count).circle")
            Text(wordScore.word)
            Spacer()
            Text(wordScore.score.description)
          }
        }
      }
    } header: {
      HStack {
        Text("Words")
        Spacer()
        Text("Score")
      }
    }
  }
}
