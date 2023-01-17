//
//  Appearance.swift
//  Aurora
//
//  Created by Alex Rozanski on 14/01/2023.
//

import Foundation

// Keep this struct internal -- expose a higher-level appearance API if configuration is desired.
//
// There are some memory-related crashes when holding this in the `Environment` if this is a struct,
// so leave this as a class for now and investigate later.
internal class Appearance {
  static func `default`() -> Appearance {
    return Appearance(
      blurColors: true,
      opacity: 1.0,
      blurRadius: 48.3
    )
  }

  let blurColors: Bool
  let opacity: Double
  let blurRadius: Double

  init(blurColors: Bool, opacity: Double, blurRadius: Double) {
    self.blurColors = blurColors
    self.opacity = opacity
    self.blurRadius = blurRadius
  }
}

// MARK: - Equatable

extension Appearance: Equatable {
  static func == (lhs: Appearance, rhs: Appearance) -> Bool {
    return lhs.blurColors == rhs.blurColors &&
    lhs.opacity == rhs.opacity &&
    lhs.blurRadius == rhs.blurRadius
  }
}

// MARK: - Mutations

extension Appearance {
  func withBlurColors(_ newBlurColors: Bool) -> Appearance {
    return Appearance(
      blurColors: newBlurColors,
      opacity: opacity,
      blurRadius: blurRadius
    )
  }

  func withOpacity(_ newOpacity: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: newOpacity,
      blurRadius: blurRadius
    )
  }

  func withBlurRadius(_ newBlurRadius: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: newBlurRadius
    )
  }
}
