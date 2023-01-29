//
//  PositionDebugColorsView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal struct PositionDebugColorsView: View {
  let colors: [NSColor]?
  
  var body: some View {
    if let colors = colors {
      HStack {
        ForEach(colors, id: \.self) { color in
          PositionDebugColorView(color: color)
        }
      }
    }
  }
}
