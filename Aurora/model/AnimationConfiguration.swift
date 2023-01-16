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
      opacityAnimationDelayRange: 0...1,
      minScaleRange: 0.9...0.95,
      maxScaleRange: 1.05...1.1,
      minOpacityRange: 0.4...0.49,
      maxOpacityRange: 0.51...0.8
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
  let minScaleRange: ClosedRange<Double>
  let maxScaleRange: ClosedRange<Double>
  let minOpacityRange: ClosedRange<Double>
  let maxOpacityRange: ClosedRange<Double>

  init(
    animateRotation: Bool,
    animateScale: Bool,
    animateOpacity: Bool,
    rotationAnimationDuration: Double,
    scaleAnimationDuration: Double,
    opacityAnimationDuration: Double,
    rotationAnimationDelayRange: ClosedRange<Double>,
    scaleAnimationDelayRange: ClosedRange<Double>,
    opacityAnimationDelayRange: ClosedRange<Double>,
    minScaleRange: ClosedRange<Double>,
    maxScaleRange: ClosedRange<Double>,
    minOpacityRange: ClosedRange<Double>,
    maxOpacityRange: ClosedRange<Double>
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
    self.minScaleRange = minScaleRange
    self.maxScaleRange = maxScaleRange
    self.minOpacityRange = minOpacityRange
    self.maxOpacityRange = maxOpacityRange
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
    lhs.opacityAnimationDelayRange == rhs.opacityAnimationDelayRange &&
    lhs.minScaleRange == rhs.minScaleRange &&
    lhs.maxScaleRange == rhs.maxScaleRange &&
    lhs.minOpacityRange == rhs.minOpacityRange &&
    lhs.maxOpacityRange == rhs.maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
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
      opacityAnimationDelayRange: newOpacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinScaleRange(_ newMinScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: newMinScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxScaleRange(_ newMaxScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: newMaxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinOpacityRange(_ newMinOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: newMinOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxOpacityRange(_ newMaxOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity,
      rotationAnimationDuration: rotationAnimationDuration,
      scaleAnimationDuration: scaleAnimationDuration,
      opacityAnimationDuration: opacityAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: newMaxOpacityRange
    )
  }
}
