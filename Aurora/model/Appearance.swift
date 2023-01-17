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
      opacity: 1,
      blurRadius: 55.1,
      orbRoundness: 1,
      orbScaleFactor: 0.4,
      orbSpacingFactor: 0.6
    )
  }

  let blurColors: Bool
  let opacity: Double
  let blurRadius: Double
  let orbRoundness: Double
  let orbScaleFactor: Double
  let orbSpacingFactor: Double

  init(
    blurColors: Bool,
    opacity: Double,
    blurRadius: Double,
    orbRoundness: Double,
    orbScaleFactor: Double,
    orbSpacingFactor: Double
  ) {
    self.blurColors = blurColors
    self.opacity = opacity
    self.blurRadius = blurRadius
    self.orbRoundness = orbRoundness
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
    lhs.orbRoundness == rhs.orbRoundness &&
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
      orbRoundness: orbRoundness,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOpacity(_ newOpacity: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: newOpacity,
      blurRadius: blurRadius,
      orbRoundness: orbRoundness,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withBlurRadius(_ newBlurRadius: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: newBlurRadius,
      orbRoundness: orbRoundness,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOrbRoundness(_ newOrbRoundness: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbRoundness: newOrbRoundness,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOrbScaleFactor(_ newOrbScaleFactor: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbRoundness: orbRoundness,
      orbScaleFactor: newOrbScaleFactor,
      orbSpacingFactor: orbSpacingFactor
    )
  }

  func withOrbSpacingFactor(_ newOrbSpacingFactor: Double) -> Appearance {
    return Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      orbRoundness: orbRoundness,
      orbScaleFactor: orbScaleFactor,
      orbSpacingFactor: newOrbSpacingFactor
    )
  }
}
