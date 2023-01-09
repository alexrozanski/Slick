//
//  BackgroundView.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import SwiftUI

internal struct BackgroundView: View {
  // Keep this struct internal -- expose a higher-level appearance API if configuration is desired.
  class Appearance: Equatable {
    static func `default`() -> Appearance {
      return Appearance(
        blurColors: true,
        opacity: 0.6,
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

    static func == (lhs: BackgroundView.Appearance, rhs: BackgroundView.Appearance) -> Bool {
      return lhs.blurColors == rhs.blurColors &&
      lhs.opacity == rhs.opacity &&
      lhs.blurRadius == rhs.blurRadius
    }
  }

  class AnimationConfiguration: Equatable {
    static func `default`() -> AnimationConfiguration {
      return AnimationConfiguration(
        animateRotation: true,
        animateScale: true,
        animateOpacity: true
      )
    }

    let animateRotation: Bool
    let animateScale: Bool
    let animateOpacity: Bool

    init(animateRotation: Bool, animateScale: Bool, animateOpacity: Bool) {
      self.animateRotation = animateRotation
      self.animateScale = animateScale
      self.animateOpacity = animateOpacity
    }

    static func == (lhs: BackgroundView.AnimationConfiguration, rhs: BackgroundView.AnimationConfiguration) -> Bool {
      return lhs.animateRotation == rhs.animateRotation &&
      lhs.animateScale == rhs.animateScale &&
      lhs.animateOpacity == rhs.animateOpacity
    }
  }

  @ObservedObject var viewModel: AuroraViewModel
  let appearance: Appearance
  let animationConfiguration: AnimationConfiguration

  @State var showColors = false

  var body: some View {
    orbs
      .onChange(of: viewModel.backgroundOrbs) { _ in
        withAnimation {
          showColors = viewModel.backgroundOrbs != nil
        }
      }
  }

  @ViewBuilder private var orbs: some View {
    if let backgroundOrbs = viewModel.backgroundOrbs, showColors {
      GeometryReader { geometry in
        ZStack {
          ForEach(backgroundOrbs, id: \.angle) { backgroundOrb in
            BackgroundOrb(viewModel: backgroundOrb, appearance: appearance, animationConfiguration: animationConfiguration)
              .frame(width: orbSize(for: geometry.size).width, height: orbSize(for: geometry.size).height)
              .offset(orbCenterOffset(for: geometry.size, angle: backgroundOrb.angle))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

private func orbSize(for viewSize: CGSize) -> CGSize {
  let sideLength = min(viewSize.width, viewSize.height) * 0.65
  return CGSize(width: sideLength, height: sideLength)
}

private func orbCenterOffset(for size: CGSize, angle: Double) -> CGSize {
  let referenceSize = CGSize(width: size.width * 0.6, height: size.height * 0.6)
  let coords = edgeCoordinates(for: angle, inRectWithSize: referenceSize)
  return CGSize(
    width: coords.x - referenceSize.width / 2.0,
    height: coords.y - referenceSize.height / 2.0
  )
}
