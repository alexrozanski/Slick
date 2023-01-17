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
      rotationAnimationDuration: 10.0,
      rotationAnimationDelayRange: 0...1,
      animateScale: true,
      scaleAnimationDuration: 10.0,
      scaleAnimationDelayRange: 0...1,
      minScaleRange: 0.9...0.95,
      maxScaleRange: 1.05...1.1,
      animateOpacity: true,
      opacityAnimationDuration: 10.0,
      opacityAnimationDelayRange: 0...1,
      minOpacityRange: 0.4...0.49,
      maxOpacityRange: 0.51...0.8
    )
  }

  let animateRotation: Bool
  let rotationAnimationDuration: Double
  let rotationAnimationDelayRange: ClosedRange<Double>

  let animateScale: Bool
  let scaleAnimationDuration: Double
  let scaleAnimationDelayRange: ClosedRange<Double>
  let minScaleRange: ClosedRange<Double>
  let maxScaleRange: ClosedRange<Double>

  let animateOpacity: Bool
  let opacityAnimationDuration: Double
  let opacityAnimationDelayRange: ClosedRange<Double>
  let minOpacityRange: ClosedRange<Double>
  let maxOpacityRange: ClosedRange<Double>

  init(
    animateRotation: Bool,
    rotationAnimationDuration: Double,
    rotationAnimationDelayRange: ClosedRange<Double>,
    animateScale: Bool,
    scaleAnimationDuration: Double,
    scaleAnimationDelayRange: ClosedRange<Double>,
    minScaleRange: ClosedRange<Double>,
    maxScaleRange: ClosedRange<Double>,
    animateOpacity: Bool,
    opacityAnimationDuration: Double,
    opacityAnimationDelayRange: ClosedRange<Double>,
    minOpacityRange: ClosedRange<Double>,
    maxOpacityRange: ClosedRange<Double>
  ) {
    self.animateRotation = animateRotation
    self.rotationAnimationDuration = rotationAnimationDuration
    self.rotationAnimationDelayRange = rotationAnimationDelayRange

    self.animateScale = animateScale
    self.scaleAnimationDuration = scaleAnimationDuration
    self.scaleAnimationDelayRange = scaleAnimationDelayRange
    self.minScaleRange = minScaleRange
    self.maxScaleRange = maxScaleRange

    self.animateOpacity = animateOpacity
    self.opacityAnimationDuration = opacityAnimationDuration
    self.opacityAnimationDelayRange = opacityAnimationDelayRange
    self.minOpacityRange = minOpacityRange
    self.maxOpacityRange = maxOpacityRange
  }
}

// MARK: - Equatable

extension AnimationConfiguration: Equatable {
  static func == (lhs: AnimationConfiguration, rhs: AnimationConfiguration) -> Bool {
    return lhs.animateRotation == rhs.animateRotation &&
    lhs.rotationAnimationDuration == rhs.rotationAnimationDuration &&
    lhs.rotationAnimationDelayRange == rhs.rotationAnimationDelayRange &&
    lhs.animateScale == rhs.animateScale &&
    lhs.scaleAnimationDuration == rhs.scaleAnimationDuration &&
    lhs.scaleAnimationDelayRange == rhs.scaleAnimationDelayRange &&
    lhs.minScaleRange == rhs.minScaleRange &&
    lhs.maxScaleRange == rhs.maxScaleRange &&
    lhs.animateOpacity == rhs.animateOpacity &&
    lhs.opacityAnimationDuration == rhs.opacityAnimationDuration &&
    lhs.opacityAnimationDelayRange == rhs.opacityAnimationDelayRange &&
    lhs.minOpacityRange == rhs.minOpacityRange &&
    lhs.maxOpacityRange == rhs.maxOpacityRange
  }
}

// MARK: - Mutations

extension AnimationConfiguration {
  func withAnimateRotation(_ newAnimateRotation: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: newAnimateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withAnimateScale(_ newAnimateScale: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: newAnimateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withAnimateOpacity(_ newAnimateOpacity: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: newAnimateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withRotationAnimationDuration(_ newRotationAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: newRotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withScaleAnimationDuration(_ newScaleAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: newScaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withOpacityAnimationDuration(_ newOpacityAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: newOpacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withRotationAnimationDelayRange(_ newRotationAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: newRotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withScaleAnimationDelayRange(_ newScaleAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: newScaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withOpacityAnimationDelayRange(_ newOpacityAnimationDelayRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: newOpacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinScaleRange(_ newMinScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: newMinScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxScaleRange(_ newMaxScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: newMaxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinOpacityRange(_ newMinOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: newMinOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxOpacityRange(_ newMaxOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayRange: rotationAnimationDelayRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayRange: scaleAnimationDelayRange,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayRange: opacityAnimationDelayRange,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: newMaxOpacityRange
    )
  }
}
