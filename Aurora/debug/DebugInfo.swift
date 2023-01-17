//
//  DebugColorInfo.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal class DebugInfo: ObservableObject {
  struct PositionInfo {
    let angle: Double
    let image: NSImage
    let colors: [NSColor]
    let edgeCoordinates: CGPoint
    let focusPoint: UnitPoint
  }

  // Returns a grid of positions indexed by y-values and x-values.
  lazy var positionGrid: [[PositionInfo?]] = {
    var horizontalCoordinates = [Int]()
    var verticalCoordinates = [Int]()

    positions.forEach { position in
      let x = Int(round(position.edgeCoordinates.x))
      let y = Int(round(position.edgeCoordinates.y))

      if !horizontalCoordinates.fuzzyContains(value: x) { horizontalCoordinates.append(x) }
      if !verticalCoordinates.fuzzyContains(value: y) { verticalCoordinates.append(y) }
    }

    var grid = [[PositionInfo?]](
      repeating: [PositionInfo?](repeating: nil, count: horizontalCoordinates.count),
      count: verticalCoordinates.count
    )

    positions.forEach { position in
      guard
        let x = horizontalCoordinates.fuzzyIndex(for: Int(round(position.edgeCoordinates.x))),
        let y = verticalCoordinates.fuzzyIndex(for: Int(round(position.edgeCoordinates.y)))
      else { return }

      grid[y][x] = position
    }

    return grid
  }()

  let positions: [PositionInfo]
  init(positions: [PositionInfo]) {
    self.positions = positions
  }
}

fileprivate let edgeCoordinateEpsilon = 10

fileprivate extension Array where Element == Int {
  func fuzzyContains(value: Int) -> Bool {
    return contains(where: { abs(value - $0) < edgeCoordinateEpsilon })
  }

  func fuzzyIndex(for value: Int) -> Int? {
    return firstIndex(where: { abs(value - $0) < edgeCoordinateEpsilon })
  }
}
