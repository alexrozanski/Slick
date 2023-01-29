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
          Circle()
            .fill(Color(cgColor: color.cgColor))
            .frame(width: 20, height: 20)
            .contextMenu {
              Text(color.hexString)
              Divider()
              Button("Copy color") {
                let pasteboard = NSPasteboard.general
                pasteboard.prepareForNewContents(with: [])
                pasteboard.setString(color.hexString, forType: .string)
              }
            }
        }
      }
    }
  }
}
