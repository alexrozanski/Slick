//
//  BackgroundOrbViewModel.swift
//  Aurora
//
//  Created by Alex Rozanski on 06/01/2023.
//

import SwiftUI

internal struct BackgroundOrbViewModel: Equatable {
  // Expressed in 0 <= degrees <= 360
  let angle: Double
  let color: NSColor

  let animateRotation: Bool
  let rotationAnimationDuration: Double
  let rotationAnimationDelay: Double
  let rotationPathRadius: Double
  let rotationCenterOffset: CGSize

  let animateScale: Bool
  let scaleAnimationDuration: Double
  let scaleAnimationDelay: Double
  let scaleAnimationStartingStep: Double
  let minScale: Double
  let maxScale: Double
  let scaleAnchor: UnitPoint

  let animateOpacity: Bool
  let opacityAnimationDuration: Double
  let opacityAnimationDelay: Double
  let opacityAnimationStartingStep: Double
  let minOpacity: Double
  let maxOpacity: Double

  init(angle: Double, color: NSColor, focusPoint: UnitPoint, animationConfiguration: AnimationConfiguration) {
    self.angle = angle
    self.color = color

    self.animateRotation = animationConfiguration.animateRotation
    self.rotationAnimationDuration = animationConfiguration.rotationAnimationDuration
    self.rotationAnimationDelay = makeDelay(for: angle, animationDuration: animationConfiguration.rotationAnimationDuration, delayOffset: animationConfiguration.rotationAnimationDelayOffset)

    self.rotationPathRadius = animationConfiguration.rotationPathRadius
    let adjustedAngle = (angle + 45) * .pi / 180
    self.rotationCenterOffset = CGSize(width: -animationConfiguration.rotationPathRadius * cos(adjustedAngle), height: -animationConfiguration.rotationPathRadius * sin(adjustedAngle))

    self.animateScale = animationConfiguration.animateScale
    self.scaleAnimationDuration = animationConfiguration.scaleAnimationDuration
    self.scaleAnimationDelay = makeDelay(for: angle, animationDuration: animationConfiguration.scaleAnimationDuration, delayOffset: animationConfiguration.scaleAnimationDelayOffset)
    self.scaleAnimationStartingStep = Double.random(in: 0...1)
    self.minScale = Double.random(in: animationConfiguration.minScaleRange)
    self.maxScale = Double.random(in: animationConfiguration.maxScaleRange)
    self.scaleAnchor = focusPoint

    self.animateOpacity = animationConfiguration.animateOpacity
    self.opacityAnimationDuration = animationConfiguration.opacityAnimationDuration
    self.opacityAnimationDelay = makeDelay(for: angle, animationDuration: animationConfiguration.opacityAnimationDuration, delayOffset: animationConfiguration.opacityAnimationDelayOffset)

    // Bias starting opacity towards 1.0 for brighter colours as this gives a nicer starting appearance.
    let startingOpacityStep = min(exp(Double(color.brightnessComponent)) - 1, 1)
    self.opacityAnimationStartingStep = max(min(startingOpacityStep + Double.random(in: -0.2...0.2), 1), 0)

    self.minOpacity = Double.random(in: animationConfiguration.minOpacityRange)
    self.maxOpacity = Double.random(in: animationConfiguration.maxOpacityRange)
  }

  init(backgroundColor: ImageColorExtractor.ExtractedColor, animationConfiguration: AnimationConfiguration) {
    self.init(
      angle: backgroundColor.angle,
      color: backgroundColor.color,
      focusPoint: UnitPoint(x: min(backgroundColor.focusPoint.x, 1), y: min(backgroundColor.focusPoint.y, 1)),
      animationConfiguration: animationConfiguration
    )
  }
}

// Parameterise the delay based on the orb's position in the background (defined by its 'angle'). Add some random
// noise to offset this angle in `delayOffset`, otherwise the phasing of the animations looks too regular because of
// symmetric values in abs(cos()). Scale this to `animationDuration` so that all animations are delayed to within a
// full cycle of the animation.
private func makeDelay(for angle: Double, animationDuration: Double, delayOffset: ClosedRange<Double>) -> Double {
  return animationDuration * abs(cos((angle + Double.random(in: delayOffset)) * .pi / 180))
}

extension BackgroundOrbViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(angle)
    hasher.combine(color)

    hasher.combine(animateRotation)
    hasher.combine(rotationAnimationDuration)
    hasher.combine(rotationAnimationDelay)
    hasher.combine(rotationPathRadius)
    hasher.combine(rotationCenterOffset.width)
    hasher.combine(rotationCenterOffset.height)

    hasher.combine(animateScale)
    hasher.combine(scaleAnimationDuration)
    hasher.combine(scaleAnimationDelay)
    hasher.combine(minScale)
    hasher.combine(maxScale)
    hasher.combine(scaleAnchor)

    hasher.combine(animateOpacity)
    hasher.combine(opacityAnimationDuration)
    hasher.combine(opacityAnimationDelay)
    hasher.combine(minOpacity)
    hasher.combine(maxOpacity)
  }
}
