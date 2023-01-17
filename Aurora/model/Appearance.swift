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
      blurRadius: 55.1,
      orbScaleFactor: 0.4,
      orbSpacingFactor: 0.6
    )
  }

  let blurColors: Bool
  let opacity: Double
  let blurRadius: Double
  let orbScaleFactor: Double
  let orbSpacingFactor: Double

  init(
    blurColors: Bool,
    opacity: Double,
    blurRadius: Double,
    orbScaleFactor: Double,
    orbSpacingFactor: Double
  ) {
    self.blurColors = blurColors
    self.opacity = opacity
    self.blurRadius = blurRadius
    self.orbScaleFactor = orbScaleFactor
    self.orbSpacingFactor = orbSpacingFactor
  }
}

// MARK: - Equatable

extension Appearance: Equatable {
  static func == (lhs: Appearance, rhs: Appearance) -> Bool {
    return lhs.blurColors == rhs.blurColors &&
    lhs.opacity == rhs.opacity &&
    lhs.blurRadius == rhs.blurRadius &&
    lhs.orbScaleFactor == rhs.orbScaleFactor &&
    lhs.orbSpacingFactor == rhs.orbSpacingFactor
  }
}

// MARK: - Mutations

extension Appearance {
  func withBlurColors(_ newBlurColors: Bool) -> Appearance {
    return Appearance(
      blurColors: newBlurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOpacity(_ newOpacity: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: newOpacity,
      blurRadius: blurRadius,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withBlurRadius(_ newBlurRadius: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: newBlurRadius,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOrbScaleFactor(_ newOrbScaleFactor: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbScaleFactor: newOrbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOrbSpacingFactor(_ newOrbSpacingFactor: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: newOrbSpacingFactor
    )
  }
}
