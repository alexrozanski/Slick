//
//  AnimationConfiguration.swift
//  Aurora
//
//  Created by Alex Rozanski on 14/01/2023.
//

import Foundation

// There are some memory-related crashes when holding this in the `Environment` if this is a struct,
// so leave this as a class for now and investigate later.
internal class AnimationConfiguration {
  static func `default`() -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: true,
      animateScale: true,
      animateOpacity: true,
      rotationAnimationDuration: 10.0,
      scaleAnimationDuration: 10.0,
      opacityAnimationDuration: 10.0,
      rotationAnimationDelayRange: 0...1,
      scaleAnimationDelayRange: 0...1,
      opacityAnimationDelayRange: 0...1
    )
  }

  let animateRotation: Bool
  let animateScale: Bool
  let animateOpacity: Bool
  let rotationAnimationDuration: Double
  let scaleAnimationDuration: Double
  let opacityAnimationDuration: Double
  let rotationAnimationDelayRange: ClosedRange<Double>
  let scaleAnimationDelayRange: ClosedRange<Double>
  let opacityAnimationDelayRange: ClosedRange<Double>

  init(
    animateRotation: Bool,
    animateScale: Bool,
    animateOpacity: Bool,
    rotationAnimationDuration: Double,
    scaleAnimationDuration: Double,
    opacityAnimationDuration: Double,
    rotationAnimationDelayRange: ClosedRange<Double>,
    scaleAnimationDelayRange: ClosedRange<Double>,
    opacityAnimationDelayRange: ClosedRange<Double>
  ) {
    self.animateRotation = animateRotation
    self.animateScale = animateScale
    self.animateOpacity = animateOpacity
    self.rotationAnimationDuration = rotationAnimationDuration
    self.scaleAnimationDuration = scaleAnimationDuration
    self.opacityAnimationDuration = opacityAnimationDuration
    self.rotationAnimationDelayRange = rotationAnimationDelayRange
    self.scaleAnimationDelayRange = scaleAnimationDelayRange
    self.opacityAnimationDelayRange = opacityAnimationDelayRange
  }
}

// MARK: - Equatable

extension AnimationConfiguration: Equatable {
  static func == (lhs: AnimationConfiguration, rhs: AnimationConfiguration) -> Bool {
    return lhs.animateRotation == rhs.animateRotation &&
    lhs.animateScale == rhs.animateScale &&
    lhs.animateOpacity == rhs.animateOpacity &&
    lhs.rotationAnimationDuration == rhs.rotationAnimationDuration &&
    lhs.scaleAnimationDuration == rhs.scaleAnimationDuration &&
    lhs.opacityAnimationDuration == rhs.opacityAnimationDuration &&
    lhs.rotationAnimationDelayRange == rhs.rotationAnimationDelayRange &&
    lhs.scaleAnimationDelayRange == rhs.scaleAnimationDelayRange &&
    lhs.opacityAnimationDelayRange == rhs.opacityAnimationDelayRange
  }
}

// MARK: - Mutations

extension AnimationConfiguration {
  func withAnimateRotation(_ newAnimateRotation: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: newAnimateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withAnimateScale(_ newAnimateScale: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: newAnimateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withAnimateOpacity(_ newAnimateOpacity: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: newAnimateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withRotationAnimationDuration(_ newRotationAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: newRotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withScaleAnimationDuration(_ newScaleAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: newScaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withOpacityAnimationDuration(_ newOpacityAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: newOpacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withRotationAnimationDelayRange(_ newRotationAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: newRotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withScaleAnimationDelayRange(_ newScaleAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: newScaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange
    )
  }

  func withOpacityAnimationDelayRange(_ newOpacityAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: newOpacityAnimationDelayRange
    )
  }
}
