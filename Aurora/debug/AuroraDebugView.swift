//
//  AuroraDebugControlsView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct AuroraDebugView: View {
  @Environment(\.debugInfo) var debugInfo: DebugInfo?
  
  public init() {}
  
  public var body: some View {
    if let debugInfo = debugInfo {
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
        .frame(maxWidth: .infinity)
      }
    }
  }
}

fileprivate extension DebugInfo.Position {
  var label: String {
    switch self {
    case .topLeft: return "Top Left"
    case .topCenter: return "Top Center"
    case .topRight: return "Top Right"
    case .centerRight: return "Center Right"
    case .bottomRight: return "Bottom Right"
    case .bottomCenter: return "Bottom Center"
    case .bottomLeft: return "Bottom Left"
    case .centerLeft: return "Center Left"
    case .angle: return "\(angle)°"
    }
  }
}
