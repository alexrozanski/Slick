//
//  DebugColorInfo.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal class DebugInfo: ObservableObject {
  enum Position: Hashable {
    case topLeft
    case topCenter
    case topRight
    case centerRight
    case bottomRight
    case bottomCenter
    case bottomLeft
    case centerLeft
    case angle(Double)

    init(angle: Double) {
      switch angle {
      case 0: self = .topLeft
      case 45: self = .topCenter
      case 90: self = .topRight
      case 135: self = .centerRight
      case 180: self = .bottomRight
      case 225: self = .bottomCenter
      case 270: self = .bottomLeft
      case 315: self = .centerLeft
      default: self = .angle(angle)
      }
    }

    var angle: Double {
      switch self {
      case .topLeft: return 0
      case .topCenter: return 45
      case .topRight: return 90
      case .centerRight: return 135
      case .bottomRight: return 180
      case .bottomCenter: return 225
      case .bottomLeft: return 270
      case .centerLeft: return 315
      case .angle(let angle): return angle
      }
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(angle)
    }
  }

  struct PositionInfo {
    let image: NSImage
    let colors: [NSColor]
  }

  let info: [Position: PositionInfo]

  init(info: [Position: PositionInfo]) {
    self.info = info
  }
}
