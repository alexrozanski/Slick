//
//  DebugColorInfo.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal class DebugInfo: ObservableObject {
  enum Position: Hashable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case angle(Double)

    init(angle: Double) {
      switch angle {
      case 0: self = .topLeft
      case 90: self = .topRight
      case 180: self = .bottomRight
      case 270: self = .bottomLeft
      default: self = .angle(angle)
      }
    }

    var angle: Double {
      switch self {
      case .topLeft: return 0
      case .topRight: return 90
      case .bottomRight: return 180
      case .bottomLeft: return 270
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

internal struct DebugInfoKey: EnvironmentKey {
  static var defaultValue: DebugInfo? = nil
}

internal extension EnvironmentValues {
  var debugInfo: DebugInfo? {
    get { self[DebugInfoKey.self] }
    set { self[DebugInfoKey.self] = newValue }
  }
}
