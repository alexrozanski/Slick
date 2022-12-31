//
//  SlickDebugControlsView.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct SlickDebugView: View {
  @Environment(\.debugInfo) var debugInfo: DebugInfo?

  public init() {}

  public var body: some View {
    if let debugInfo = debugInfo {
      VStack {
        ScrollView {
          VStack {
            ForEach(Array(debugInfo.info.keys.sorted(by: { p1, p2 in p1.angle < p2.angle })), id: \.self) { position in
              if let info = debugInfo.info[position] {
                DebugCornerView(
                  label: position.label,
                  sampledImage: info.image,
                  colors: info.colors
                )
                .padding(.bottom, 24)
              }
            }
          }
          .padding()
        }
      }
    }
  }
}

fileprivate extension DebugInfo.Position {
  var label: String {
    switch self {
    case .topLeft: return "Top Left"
    case .topRight: return "Top Right"
    case .bottomRight: return "Bottom Right"
    case .bottomLeft: return "Bottom Left"
    case .angle: return "\(angle)°"
    }
  }
}
