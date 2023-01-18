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
      rotationAnimationDuration: 4.4,
      rotationAnimationDelayOffset: -30...30,
      rotationCenterOffsetRange: 0.01...0.06,
      animateScale: true,
      scaleAnimationDuration: 10.0,
      scaleAnimationDelayOffset: -30...30,
      minScaleRange: 0.9...0.95,
      maxScaleRange: 1.05...1.1,
      animateOpacity: true,
      opacityAnimationDuration: 10.0,
      opacityAnimationDelayOffset: -30...30,
      minOpacityRange: 0.4...0.47,
      maxOpacityRange: 0.66...0.95
    )
  }

  let animateRotation: Bool
  let rotationAnimationDuration: Double
  let rotationAnimationDelayOffset: ClosedRange<Double>
  let rotationCenterOffsetRange: ClosedRange<Double>

  let animateScale: Bool
  let scaleAnimationDuration: Double
  let scaleAnimationDelayOffset: ClosedRange<Double>
  let minScaleRange: ClosedRange<Double>
  let maxScaleRange: ClosedRange<Double>

  let animateOpacity: Bool
  let opacityAnimationDuration: Double
  let opacityAnimationDelayOffset: ClosedRange<Double>
  let minOpacityRange: ClosedRange<Double>
  let maxOpacityRange: ClosedRange<Double>

  init(
    animateRotation: Bool,
    rotationAnimationDuration: Double,
    rotationAnimationDelayOffset: ClosedRange<Double>,
    rotationCenterOffsetRange: ClosedRange<Double>,
    animateScale: Bool,
    scaleAnimationDuration: Double,
    scaleAnimationDelayOffset: ClosedRange<Double>,
    minScaleRange: ClosedRange<Double>,
    maxScaleRange: ClosedRange<Double>,
    animateOpacity: Bool,
    opacityAnimationDuration: Double,
    opacityAnimationDelayOffset: ClosedRange<Double>,
    minOpacityRange: ClosedRange<Double>,
    maxOpacityRange: ClosedRange<Double>
  ) {
    self.animateRotation = animateRotation
    self.rotationAnimationDuration = rotationAnimationDuration
    self.rotationAnimationDelayOffset = rotationAnimationDelayOffset
    self.rotationCenterOffsetRange = rotationCenterOffsetRange

    self.animateScale = animateScale
    self.scaleAnimationDuration = scaleAnimationDuration
    self.scaleAnimationDelayOffset = scaleAnimationDelayOffset
    self.minScaleRange = minScaleRange
    self.maxScaleRange = maxScaleRange

    self.animateOpacity = animateOpacity
    self.opacityAnimationDuration = opacityAnimationDuration
    self.opacityAnimationDelayOffset = opacityAnimationDelayOffset
    self.minOpacityRange = minOpacityRange
    self.maxOpacityRange = maxOpacityRange
  }
}

// MARK: - Equatable

extension AnimationConfiguration: Equatable {
  static func == (lhs: AnimationConfiguration, rhs: AnimationConfiguration) -> Bool {
    return lhs.animateRotation == rhs.animateRotation &&
    lhs.rotationAnimationDuration == rhs.rotationAnimationDuration &&
    lhs.rotationAnimationDelayOffset == rhs.rotationAnimationDelayOffset &&
    lhs.rotationCenterOffsetRange == rhs.rotationCenterOffsetRange &&
    lhs.animateScale == rhs.animateScale &&
    lhs.scaleAnimationDuration == rhs.scaleAnimationDuration &&
    lhs.scaleAnimationDelayOffset == rhs.scaleAnimationDelayOffset &&
    lhs.minScaleRange == rhs.minScaleRange &&
    lhs.maxScaleRange == rhs.maxScaleRange &&
    lhs.animateOpacity == rhs.animateOpacity &&
    lhs.opacityAnimationDuration == rhs.opacityAnimationDuration &&
    lhs.opacityAnimationDelayOffset == rhs.opacityAnimationDelayOffset &&
    lhs.minOpacityRange == rhs.minOpacityRange &&
    lhs.maxOpacityRange == rhs.maxOpacityRange
  }
}

// MARK: - Rotation Mutations

extension AnimationConfiguration {
  func withAnimateRotation(_ newAnimateRotation: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: newAnimateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withRotationAnimationDuration(_ newRotationAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: newRotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withRotationAnimationDelayOffset(_ newRotationAnimationDelayOffset: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: newRotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withRotationCenterOffsetRange(_ newRotationCenterOffsetRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: newRotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }
}

// MARK: - Scale Mutations

extension AnimationConfiguration {
  func withAnimateScale(_ newAnimateScale: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: newAnimateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withScaleAnimationDuration(_ newScaleAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: newScaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withScaleAnimationDelayOffset(_ newScaleAnimationDelayOffset: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: newScaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinScaleRange(_ newMinScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: newMinScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxScaleRange(_ newMaxScaleRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: newMaxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }
}

// MARK: - Opacity Mutations

extension AnimationConfiguration {
  func withAnimateOpacity(_ newAnimateOpacity: Bool) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: newAnimateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withOpacityAnimationDuration(_ newOpacityAnimationDuration: Double) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: newOpacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withOpacityAnimationDelayOffset(_ newOpacityAnimationDelayOffset: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: newOpacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMinOpacityRange(_ newMinOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: newMinOpacityRange,
      maxOpacityRange: maxOpacityRange
    )
  }

  func withMaxOpacityRange(_ newMaxOpacityRange: ClosedRange<Double>) -> AnimationConfiguration {
    return AnimationConfiguration(
      animateRotation: animateRotation,
      rotationAnimationDuration: rotationAnimationDuration,
      rotationAnimationDelayOffset: rotationAnimationDelayOffset,
      rotationCenterOffsetRange: rotationCenterOffsetRange,
      animateScale: animateScale,
      scaleAnimationDuration: scaleAnimationDuration,
      scaleAnimationDelayOffset: scaleAnimationDelayOffset,
      minScaleRange: minScaleRange,
      maxScaleRange: maxScaleRange,
      animateOpacity: animateOpacity,
      opacityAnimationDuration: opacityAnimationDuration,
      opacityAnimationDelayOffset: opacityAnimationDelayOffset,
      minOpacityRange: minOpacityRange,
      maxOpacityRange: newMaxOpacityRange
    )
  }
}
