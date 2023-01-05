//
//  DebugCornerView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal struct DebugCornerView: View {
  let label: String
  let sampledImage: NSImage?
  let colors: [NSColor]?

  var body: some View {
    VStack {
      Text(label).fontWeight(.semibold)
      if let sampledImage = sampledImage {
        Image(nsImage: sampledImage)
      }
      DebugCornerColorsView(colors: colors)
    }
  }
}
