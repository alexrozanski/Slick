//
//  DebugCornerColorsView.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal struct DebugCornerColorsView: View {
  let colors: [NSColor]?
  
  var body: some View {
    if let colors = colors {
      HStack {
        ForEach(colors, id: \.self) {
          Circle()
            .fill(Color(cgColor: $0.cgColor))
            .frame(width: 20, height: 20)
        }
      }
    }
  }
}
