//
//  WordScoring.swift
//  WordScramble
//
//  Created by Zaid Neurothrone on 2022-10-04.
//

import Foundation

struct WordScoring: Identifiable {
  let id = UUID().uuidString
  
  let word: String
  var score: Int
}
