//
//  PositionDebugView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal struct PositionDebugView: View {
  let label: String
  let sampledImage: NSImage?
  let colors: [NSColor]?
  let focusPoint: UnitPoint

  var body: some View {
    VStack {
      Text(label).fontWeight(.semibold)
      if let sampledImage = sampledImage {
        GeometryReader { geometry in
          ZStack {
            Image(nsImage: sampledImage)
              .resizable()
            Circle()
              .fill(.white)
              .frame(width: 10, height: 10)
              .shadow(color: .black.opacity(0.5), radius: 3)
              .position(x: geometry.size.width * focusPoint.x, y: geometry.size.height * focusPoint.y)
          }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: sampledImage.size.width / screenScale(), maxHeight: sampledImage.size.height / screenScale())
      }
      PositionDebugColorsView(colors: colors)
    }
  }
}

private func screenScale() -> CGFloat {
  return NSScreen.main?.backingScaleFactor ?? 1
}