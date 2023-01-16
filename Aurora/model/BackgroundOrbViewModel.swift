//
//  BackgroundOrbViewModel.swift
//  Aurora
//
//  Created by Alex Rozanski on 06/01/2023.
//

import Cocoa

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

  let animateOpacity: Bool
  let opacityAnimationDuration: Double
  let opacityAnimationDelay: Double
  let minOpacity: Double
  let maxOpacity: Double

  init(angle: Double, color: NSColor, animationConfiguration: AnimationConfiguration) {
    self.angle = angle
    self.color = color

    self.animateRotation = animationConfiguration.animateRotation
    self.rotationAnimationDuration = animationConfiguration.rotationAnimationDuration
    self.rotationAnimationDelay = Double.random(in: animationConfiguration.rotationAnimationDelayRange)
    self.rotationCenterOffset = CGPoint(x: Double.random(in: 0.45...0.495), y: Double.random(in: 0.45...0.495))

    self.animateScale = animationConfiguration.animateScale
    self.scaleAnimationDuration = animationConfiguration.scaleAnimationDuration
    self.scaleAnimationDelay = Double.random(in: animationConfiguration.scaleAnimationDelayRange)
    self.minScale = Double.random(in: 0.9...0.95)
    self.maxScale = Double.random(in: 1.05...1.1)

    self.animateOpacity = animationConfiguration.animateOpacity
    self.opacityAnimationDuration = animationConfiguration.opacityAnimationDuration
    self.opacityAnimationDelay = Double.random(in: animationConfiguration.opacityAnimationDelayRange)
    self.minOpacity = Double.random(in: 0.4...0.49)
    self.maxOpacity = Double.random(in: 0.51...0.8)
  }

  init(backgroundColor: ImageColorExtractor.BackgroundColor, animationConfiguration: AnimationConfiguration) {
    self.init(angle: backgroundColor.angle, color: backgroundColor.color, animationConfiguration: animationConfiguration)
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

    hasher.combine(animateOpacity)
    hasher.combine(opacityAnimationDuration)
    hasher.combine(opacityAnimationDelay)
    hasher.combine(minOpacity)
    hasher.combine(maxOpacity)
  }
}
