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
        Grid {
          ForEach(Array(debugInfo.positionGrid.enumerated()), id: \.offset) { index, row in
            GridRow {
              ForEach(Array(row.enumerated()), id: \.offset) { index, position in
                if let position {
                  PositionDebugView(
                    label: position.label,
                    sampledImage: position.image,
                    colors: position.colors,
                    focusPoint: position.focusPoint
                  )
                } else {
                  Spacer()
                }
              }
            }
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
      }
    }
  }
}

fileprivate extension DebugInfo.PositionInfo {
  var label: String {
    switch angle {
    case 0: return "Top Left (0°)"
    case 45: return "Top Center (45°)"
    case 90: return "Top Right (90°)"
    case 135: return "Center Right (135°)"
    case 180: return "Bottom Right (180°)"
    case 225: return "Bottom Center (225°)"
    case 270: return "Bottom Left (270°)"
    case 315: return "Center Left (315°)"
    default: return "\(angle)°"
    }
  }
}
