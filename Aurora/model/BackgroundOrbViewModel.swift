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
  let rotationCenterOffset: CGPoint

  let animateScale: Bool
  let scaleAnimationDuration: Double
  let scaleAnimationDelay: Double
  let minScale: Double
  let maxScale: Double
  let scaleAnchor: UnitPoint

  let animateOpacity: Bool
  let opacityAnimationDuration: Double
  let opacityAnimationDelay: Double
  let minOpacity: Double
  let maxOpacity: Double

  init(angle: Double, color: NSColor, focusPoint: UnitPoint, animationConfiguration: AnimationConfiguration) {
    self.angle = angle
    self.color = color

    self.animateRotation = animationConfiguration.animateRotation
    self.rotationAnimationDuration = animationConfiguration.rotationAnimationDuration
    self.rotationAnimationDelay = Double.random(in: animationConfiguration.rotationAnimationDelayRange)
    self.rotationCenterOffset = CGPoint(x: Double.random(in: 0.45...0.495), y: Double.random(in: 0.45...0.495))

    self.animateScale = animationConfiguration.animateScale
    self.scaleAnimationDuration = animationConfiguration.scaleAnimationDuration
    self.scaleAnimationDelay = Double.random(in: animationConfiguration.scaleAnimationDelayRange)
    self.minScale = Double.random(in: animationConfiguration.minScaleRange)
    self.maxScale = Double.random(in: animationConfiguration.maxScaleRange)
    self.scaleAnchor = focusPoint

    self.animateOpacity = animationConfiguration.animateOpacity
    self.opacityAnimationDuration = animationConfiguration.opacityAnimationDuration
    self.opacityAnimationDelay = Double.random(in: animationConfiguration.opacityAnimationDelayRange)
    self.minOpacity = Double.random(in: animationConfiguration.minOpacityRange)
    self.maxOpacity = Double.random(in: animationConfiguration.maxOpacityRange)
  }

  init(backgroundColor: ImageColorExtractor.BackgroundColor, animationConfiguration: AnimationConfiguration) {
    self.init(
      angle: backgroundColor.angle,
      color: backgroundColor.color,
      focusPoint: UnitPoint(x: min(backgroundColor.focusPoint.x, 1), y: min(backgroundColor.focusPoint.y, 1)),
      animationConfiguration: animationConfiguration
    )
  }
}

extension BackgroundOrbViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(angle)
    hasher.combine(color)

    hasher.combine(animateRotation)
    hasher.combine(rotationAnimationDuration)
    hasher.combine(rotationAnimationDelay)
    hasher.combine(rotationCenterOffset.x)
    hasher.combine(rotationCenterOffset.y)

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
