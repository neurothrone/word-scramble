//
//  TotalScoreTextView.swift
//  WordScramble
//
//  Created by Zaid Neurothrone on 2022-10-04.
//

import SwiftUI

struct TotalScoreTextView: View {
  let totalScore: Int
  
  var body: some View {
    HStack {
      Text("Total score: ")
        .foregroundColor(.white)
      Text(totalScore.formatted())
        .foregroundColor(.purple)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(
      LinearGradient(
        colors: [.purple, .black],
        startPoint: .leading,
        endPoint: .trailing)
    )
    .font(.title)
  }
}

struct TotalScoreTextView_Previews: PreviewProvider {
  static var previews: some View {
    TotalScoreTextView(totalScore: .zero)
  }
}
